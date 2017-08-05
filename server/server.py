from punter import Punter

import json
import sys
from subprocess import Popen, PIPE
import time
from queue import Queue

class Server(object):
    def __init__(self, mapfile, scripts):
        self.phase = "INIT"
        self.punters = self.init_punters(scripts)
        self.n = len(self.punters)
        self.moves = self.init_moves()
        self.map = self.init_map(mapfile)
        self.r = len(self.map["rivers"])
        self.graph = self.init_graph()
        self.dists = self.init_dists()

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

    def init_graph(self):
        graph = {site["id"]:{} for site in self.map["sites"]}
        for river in self.map["rivers"]:
            s = river["source"]
            t = river["target"]
            graph[s][t] = None
            graph[t][s] = None
        return graph

    def init_dists(self):
        dists = {}
        for mine in self.map["mines"]:
            dists[mine] = {site["id"]:-1 for site in self.map["sites"]}
            dists[mine][mine] = 0
            q = Queue()
            q.put(mine)
            while not q.empty():
                s = q.get()
                for t in self.graph[s]:
                    if dists[mine][t] < 0:
                        dists[mine][t] = dists[mine][s] + 1
                        q.put(t)
            for s in dists[mine]:
                if dists[mine][s] < 0:
                    dists[mine][s] = 0
                else:
                    dists[mine][s] = dists[mine][s] * dists[mine][s]
        return dists

    def run(self):
        self.phase = "SETUP"
        for punter in self.punters:
            punter.open_proc()
            self.hand_shake(punter)
            msg = {"punter": punter.id, "punters": self.n, "map": self.map}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            # self.log("setup reply from punter %d" % (punter.id))
            # self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]

        self.phase = "GAMEPLAY"
        for i in range(self.r):
            punter = self.punters[i % self.n]
            punter.open_proc()
            self.hand_shake(punter)
            msg = {"move": {"moves": self.moves[-self.n:]}, "state": punter.state}
            packet = self.make_packet(msg)
            out, err = punter.proc.communicate(packet)
            # self.log("game play reply from punter %d in %d turn" % (punter.id, i))
            # self.log(out)
            reply = json.loads(out.split(":", 1)[1])
            punter.state = reply["state"]
            del reply["state"]
            print(reply)
            if "claim" in reply:
                self.update_graph(reply["claim"], punter)
            self.moves.append(reply)

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

    def update_graph(self, claim, punter): #TODO: error handling
        s = claim["source"]
        t = claim["target"]
        self.graph[s][t] = punter.id
        self.graph[t][s] = punter.id

    def calc_score(self, punter):
        id = punter.id
        dist = {site["id"]:-1 for site in self.map["sites"]}

        reachable = {}



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
        s = json.dumps(msg, separators=(',', ':'))
        l = len(s)
        return str(l) + ":" + s

    def log(self, msg):
        print(msg, file = sys.stderr)

mapfile = sys.argv[1]
names = sys.argv[2:]

server = Server(mapfile, names)
server.run()