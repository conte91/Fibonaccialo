import sys
import cleverbot
import os

mycb=cleverbot.Session()

while True:
    content=raw_input()
    sys.stderr.write('Received:'+content+'\n')
    sys.stderr.flush()
    answer=mycb.Ask(content)
    sys.stderr.write('Reply: '+answer+'\n')
    sys.stderr.flush()
    print(answer)
    sys.stdout.flush()
