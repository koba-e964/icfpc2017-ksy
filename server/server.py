import sys
from subprocess import Popen, PIPE

if len(sys.argv) < 3:
    print("error")
    sys.exit(1)

n = sys.argv[1]
players = sys.argv[2:]
