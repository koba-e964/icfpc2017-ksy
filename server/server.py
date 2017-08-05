from punter import Punter

import json
import sys
from subprocess import Popen, PIPE
import time

class Server(object):
    def __init__(self, mapfile, scripts):
        self.phase = "INIT"
        self.punters = self.init_punters(scripts)
        self.n = len(self.punters)
        self.moves = self.init_moves()
        self.map = self.init_map(mapfile)
        self.r = len(self.map["rivers"])

    def init_punters(self, scripts):
        punters = []
        for i in range(len(scripts)):
            punters.append(Punter(i, scripts[i]))
        return punters

    def init_moves(self):
        moves = []
        for punter in self.punters:
            moves.append({"pass": {"punter": punter.id}})
        return moves

    def init_map(self, mapfile):
        f = open(mapfile)
        mp = json.load(f)
        f.close()
        return mp

    def run(self):
        self.phase = "SETUP"
        for punter in self.punters:
            punter.open_proc()
            self.hand_shake(punter)
            msg = {"punter": punter.id, "punters": self.n, "map": self.map}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            self.log("setup reply from punter %d" % (punter.id))
            self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]

        self.phase = "GAMEPLAY"
        for i in range(len(self.map["rivers"])):
            punter = self.punters[i % self.n]
            punter.open_proc()
            self.hand_shake(punter)
            msg = {"move": {"moves": self.moves}, "state": punter.state}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            self.log("game play reply from punter %d in %d turn" % (punter.id, i))
            self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]
            del reply["state"]
            self.moves.append(reply) # TODO: trim moves

        self.phase = "SCORING"
        scores = []
        for punter in self.punters:
            punter.score = 0 #TODO: calc score
            scores.append({"punter": punter.id, "score": punter.score})
        for punter in self.punters:
            punter.open_proc()
            self.hand_shake(punter)
            msg = {"stop": {"moves": self.moves, "scores": scores}, "state": punter.state}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)

        print(scores)

    def hand_shake(self, punter):
        reply = self.rcv_json(punter.proc)
        msg = {"you": reply["me"]}
        packet = self.make_packet(msg)
        punter.proc.stdin.write(packet)

    def rcv_json(self, proc):
        s = ""
        while True:
            c = proc.stdout.read(1)
            if c == ":": break
            s += c

        l = int(s)
        json_str = proc.stdout.read(l)
        return json.loads(json_str)

    def make_packet(self, msg):
        s = self.dump(msg)
        l = len(s)
        return str(l) + ":" + s

    def dump(self, msg):
        return json.dumps(msg, separators=(',', ':'))

    def log(self, msg):
        print(msg, file = sys.stderr)

mapfile = sys.argv[1]
names = sys.argv[2:]

server = Server(mapfile, names)
server.run()