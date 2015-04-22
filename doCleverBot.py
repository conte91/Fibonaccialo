import cleverbot
import os

mycb=cleverbot.Session()
pipeFile=os.open('/tmp/cleverpipe', os.O_RDONLY)
while True:
    content=os.read(pipeFile, 1024)
    print(content)
    answer=mycb.Ask(content)
    with open("/tmp/cleverreply", "w") as rFile:
        rFile.write(answer)
    os.remove("/tmp/cleverack")
