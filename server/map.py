from queue import Queue
import json

class Map(object):
    def __init__(self, mapfile):
        self.map = self.init_map(mapfile)
        self.r = len(self.map["rivers"])
        self.graph = self.init_graph()
        self.dists = self.init_dists()

    def init_map(self, mapfile):
        f = open(mapfile)
        m = json.load(f)
        f.close()
        return m

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

    def update_graph(self, claim, punter): #TODO: error handling
        s = claim["source"]
        t = claim["target"]
        self.graph[s][t] = punter.id
        self.graph[t][s] = punter.id

    def calc_score(self, punter):
        score = 0
        for mine in self.map["mines"]:
            reachable = {site["id"]:False for site in self.map["sites"]}
            reachable[mine] = True
            q = Queue()
            q.put(mine)
            while not q.empty():
                s = q.get()
                for t in self.graph[s]:
                    if not reachable[t] and self.graph[s][t] == punter.id:
                        reachable[t] = True
                        q.put(t)
            for s in reachable:
                if reachable[s]:
                    score += self.dists[mine][s]
        return score
