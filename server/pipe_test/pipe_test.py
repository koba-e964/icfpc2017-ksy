import subprocess
from subprocess import PIPE

pipe = subprocess.Popen("python echo1.py", shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=False)

pipe.stdin.write(b"hoge")
pipe.stdin.flush()

for line in iter(pipe.stdout.readline,''):
   print(line)
   break

out, err = pipe.communicate(line)

print(out)
print(err)