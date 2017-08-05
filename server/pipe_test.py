import subprocess
from subprocess import PIPE

pipe = subprocess.Popen("python echo1.py", shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True)
out, err = pipe.communicate('2\n3 4\nhoge')
print(out)
print(err)

# with subprocess.Popen(["python", "echo2.py"], shell=True, stdin=PIPE, stdout=PIPE, stderr=PIPE, universal_newlines=True) as pipe:
#     # sort コマンドへテキスト入力して、結果を受け取る
#     out, err = pipe.communicate('One\n')
#     print(out)
#     print(err)