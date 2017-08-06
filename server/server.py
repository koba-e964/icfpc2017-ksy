from punter import Punter
from map import Map

import json
import sys
import time
from queue import Queue
from subprocess import Popen, PIPE

class Server(object):
    def __init__(self, mapfile, scripts):
        self.phase = "INIT"
        self.punters = self.init_punters(scripts)
        self.n = len(self.punters)
        self.moves = self.init_moves()
        self.map = Map(mapfile)

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

    def run(self):
        self.phase = "SETUP"
        for punter in self.punters:
            self.open_proc(punter)
            self.hand_shake(punter)
            msg = {"punter": punter.id, "punters": self.n, "map": self.map.map}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            # self.log("setup reply from punter %d" % (punter.id))
            # self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]

        self.phase = "GAMEPLAY"
        for i in range(self.map.r):
            punter = self.punters[i % self.n]
            self.open_proc(punter)
            self.hand_shake(punter)
            msg = {"move": {"moves": self.moves[-self.n:]},
                   "state": punter.state}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            # self.log("game play reply from punter %d in %d turn" % (punter.id, i))
            # self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]
            del reply["state"]
            self.log(reply)
            if "claim" in reply:
                self.map.update_graph(reply["claim"], punter)
            self.moves.append(reply)

        self.phase = "SCORING"
        scores = []
        for punter in self.punters:
            punter.score = self.map.calc_score(punter)
            scores.append({"punter": punter.id, "score": punter.score})
        for punter in self.punters:
            self.open_proc(punter)
            self.hand_shake(punter)
            msg = {"stop": {"moves": self.moves, "scores": scores},
                   "state": punter.state}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)

        log = {"map": self.map.map,
                "moves": self.moves[2:],
                "scores": scores}
        print(json.dumps(log, separators=(',', ':')))

    def open_proc(self, punter):
        punter.proc = Popen("ruby " + punter.script, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)

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

mapfile = sys.argv[1]
names = sys.argv[2:]

server = Server(mapfile, names)
server.run()
