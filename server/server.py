from punter import Punter
from map import Map

import json
import sys
import time
from queue import Queue
from subprocess import Popen, PIPE

class Server(object):
    def __init__(self, mapfile, commands):
        self.phase = "INIT"
        self.punters = self.init_punters(commands)
        self.n = len(self.punters)
        self.moves = self.init_moves()
        self.map = Map(mapfile)
        self.evals = []

    def init_punters(self, commands):
        punters = []
        for i in range(len(commands)):
            punters.append(Punter(i, commands[i]))
        return punters

    def init_moves(self):
        moves = []
        for punter in self.punters:
            moves.append({"pass": {"punter": punter.id}})
        return moves

    def run(self):
        self.phase = "SETUP"
        for punter in self.punters:
            msg = {"punter": punter.id, "punters": self.n, "map": self.map.map}

            reply, err, t = self.communicate(punter, msg, 10.0)
            punter.state = reply["state"]

            self.log("setup phase of punter %d (%f sec):" % (punter.id, t))
            self.log(err)

        self.phase = "GAMEPLAY"
        for i in range(self.map.r):
            punter = self.punters[i % self.n]
            msg = {"move": {"moves": self.moves[-self.n:]},
                   "state": punter.state}

            reply, err, t = self.communicate(punter, msg, 1.0)
            punter.state = reply["state"]

            ev = 0
            if "eval" in reply["state"]:
                ev = reply["state"]["eval"]
            self.evals.append({"punter": punter.id, "eval": ev})

            if "claim" in reply:
                self.map.update_graph(reply["claim"], punter)

            del reply["state"]
            self.moves.append(reply)

            self.log("gameplay phase of punter %d, turn %d (%f sec):" % (punter.id, i + 1, t))
            self.log(err)

        self.phase = "SCORING"
        scores = self.cacl_scores()
        for punter in self.punters:
            msg = {"stop": {"moves": self.moves, "scores": scores},
                   "state": punter.state}

            reply, err, t = self.communicate(punter, msg, 20.0)

            self.log("scoring phase of punter %d:" % (punter.id))
            self.log(err)

        self.log("result:")
        self.log(scores)

        log = {"map": self.map.map,
                "punters": self.n,
                "moves": self.moves[self.n:],
                "evals": self.evals,
                "scores": scores}
        return log

    def communicate(self, punter, msg, timeout):
        self.open_proc(punter)
        self.hand_shake(punter)

        packet = self.make_packet(msg)
        t = time.time()
        out, err = punter.proc.communicate(packet, timeout = timeout)
        t = time.time() - t
        reply = {}
        if len(out) > 0:
            reply = json.loads(out.split(":", 1)[1])

        return (reply, err, t)

    def cacl_scores(self):
        scores = []
        for punter in self.punters:
            punter.score = self.map.calc_score(punter)
            scores.append({"punter": punter.id, "score": punter.score})
        return scores

    def open_proc(self, punter):
        punter.proc = Popen(punter.command, shell=True,
                            stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)

    def hand_shake(self, punter):
        reply = self.rcv_json(punter.proc)
        msg = {"you": reply["me"]}
        packet = self.make_packet(msg)
        punter.proc.stdin.write(packet)

    def rcv_json(self, proc):
        s = ""
        while True:
            c = proc.stdout.read(1)
            if c == ":":
                break
            s += c

        l = int(s)
        json_str = proc.stdout.read(l)
        return json.loads(json_str)

    @staticmethod
    def make_packet(msg):
        s = json.dumps(msg, separators=(',', ':'))
        l = len(s)
        return str(l) + ":" + s

    @staticmethod
    def log(msg):
        print(msg, file=sys.stderr)

if __name__ == "__main__":
    mapfile = sys.argv[1]
    commands = sys.argv[2:]

    server = Server(mapfile, commands)
    log = server.run()
    print(json.dumps(log, separators=(',', ':')))