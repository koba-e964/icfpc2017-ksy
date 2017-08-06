from subprocess import Popen, PIPE

class Punter(object):
    def __init__(self, id, script):
        self.state = ""
        self.id = id
        self.script = script
        self.proc = None
        self.score = 0