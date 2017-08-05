#!/Users/wataru/.pyenv/shims/python
import json

class Config(object):
    def __init__(self, filename):
        f = open(filename)
        params = json.load(f)
        f.close()
        self.time_start = params["time_start"]
        self.time_end = params["time_end"]
        self.tau = params["tau"]
        self.time_taskA = self.time_start + 3
        self.time_taskB = int(self.time_start + 1.5 * self.tau)

        self.input_min = params["input_min"]
        self.input_max = params["input_max"]
        self.input_range = self.input_max - self.input_min
        self.input_levels = params["input_levels"]
        self.input_step = self.input_range / self.input_levels