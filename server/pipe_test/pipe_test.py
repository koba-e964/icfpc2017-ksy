#! /usr/bin/python

import sys
from subprocess import PIPE, Popen

pipe = Popen("./echo1.py", shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)

pipe.stdin.write("20\n")
pipe.stdin.flush()

line = pipe.stdout.readline()
print(line)

out, err = pipe.communicate(line)

print(out)
print(err)