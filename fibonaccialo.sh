#!/bin/sh
function aspettaMSG(){
  while :
  do
    if ( fbcmd INBOX new |grep -e "snippet" -e "to/from" > $TMPMSGFILE 2>/dev/null)
    then
      #echo "Received "
      #cat $TMPMSGFILE
      #echo "END."
      SENDER=`head -n 1 $TMPMSGFILE|sed -e 's:^.*to/from[ \t]*\(.*\)$:\1:g'`
      MESSAGE=`tail -n 1 $TMPMSGFILE|sed -e 's:^.*snippet[ \t]*\(.*\)$:\1:g'`
      if [[ "$SENDER" == "$DESIREDSENDER" ]]
      then
        #echo -n "Received: $MESSAGE"
        echo $MESSAGE > $MSGFILE
        break
      else
        sleep 1
      fi
    else
      sleep 1
    fi
  done
}

function tieniApertoIlPipe() {
  echo "Opening $1..."
  while :
  do
    sleep 10000
  done > "$1"
}
MESSAGGIO=""
DESIREDSENDER=$1
THEPIPE=/tmp/cleverpipe
XMPPPIPE=/tmp/xmpplol

echo "Recreating FIFO.."
rm "$THEPIPE"
mkfifo "$THEPIPE"
rm "$XMPPIPE"
mkfifo "$XMPPIPE"
echo "Spawning keeper of the Seven Keys.."
tieniApertoIlPipe $THEPIPE &
tieniApertoIlPipe $XMPPPIPE &
echo "Spawning pipe listener.."
python2 doCleverBot.py &
echo "Spawning FB writer to chat with $1 ($2@chat.facebook.com).."
cat "$XMPPPIPE" | sendxmpp "$2"@chat.facebook.com -t -d -i &
echo "(Waiting..)"
sleep 5
echo "Done."

TMPMSGFILE=/tmp/`whoami`.tmp.themsg
MSGFILE=/tmp/`whoami`.themsg
REPLYFILE=/tmp/cleverreply
ACKFILE=/tmp/cleverack

while :
do
  aspettaMSG
  messaggio=`cat $MSGFILE`
  echo "Received: $messaggio"
  echo "$messaggio" > $THEPIPE
  touch "$ACKFILE"
  while [ -f "$ACKFILE" ] 
  do
    sleep 1
  done
  risposta=`cat $REPLYFILE`
  echo "Risposta: $risposta" 
  echo "$risposta" > "$XMPPPIPE"
  aspettaMSG
done
