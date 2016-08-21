#!/bin/bash
function aspettaMSG(){
  while :
  do
    if fbcmd INBOX new |grep -e "snippet" -e "to/from" > "$TMPMSGFILE" 2>/dev/null
    then
      #echo "Received "
      #cat $TMPMSGFILE
      #echo "END."
      SENDER=$(sed -e '1 { s:^.*to/from[ \t]*\(.*\)$:\1:g; q; }' "$TMPMSGFILE")
      MESSAGE=$(sed -ne '$ { s:^.*snippet[ \t]*\(.*\)$:\1:g; p; }' "$TMPMSGFILE")
      if [[ "$SENDER" == "$DESIREDSENDER" ]]
      then
        #echo -n "Received: $MESSAGE"
        echo "$MESSAGE" > "$MSGFILE"
        break
      else
        sleep 1
      fi
    else
      sleep 1
    fi
  done
}

MESSAGGIO=""
DESIREDSENDER=$1

TMPMSGFILE=/tmp/`whoami`.tmp.themsg
MSGFILE=/tmp/`whoami`.themsg

echo "Enter username:"
read user
echo "Enter password:"
read -rs password
echo "Enter the ID of the person you want to talk to:"
read name
./fibo "-$name@chat.facebook.com" "$user" "$password" | python2 doCleverBot.py | sendxmpp -t -i "$name@chat.facebook.com" 
