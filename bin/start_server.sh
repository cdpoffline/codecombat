#!/bin/bash

cd "`dirname \"$0\"`"

./stop_server.sh

if [ -n "$1" ]
then
  HOME="$1"
fi

source "$HOME/.nvm/nvm.sh"

( ( cd ../codecombat ; npm start ; ) 1>codecombat.log 2>codecombat.log ; ) &
echo -n $! >codecombat.pid
