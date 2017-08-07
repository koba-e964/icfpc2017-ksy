from subprocess import Popen, PIPE

class Punter(object):
    def __init__(self, id, command):
        self.state = ""
        self.id = id
        self.command = command
        self.proc = None
        self.score = 0