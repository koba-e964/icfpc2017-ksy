from subprocess import Popen, PIPE

class Punter(object):
    def __init__(self, id, script):
        self.state = ""
        self.id = id
        self.script = script
        self.proc = None

    def open_proc(self):
        self.proc = Popen("ruby " + self.script, shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)
