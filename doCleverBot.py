# (c) 2015 Simone Baratta - conte91 <at> gmail <dot> com
# THIS SOFTWARE IS RELEASED UNDER GNU GPLv3 LICENSE.
# YOU CAN FIND A COPY OF IT AT http://www.gnu.org/licenses/gpl.html


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
