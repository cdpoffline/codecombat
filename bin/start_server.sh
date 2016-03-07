#!/bin/bash

cd "`dirname \"$0\"`"

user=`whoami`
if [ -n "$1" ]
then
  user=$1
fi

./stop_server.sh

if [ -n "$1" ]
then
  HOME="$1"
fi

sudo -u mongodb bash -c "mongod &"

source "$HOME/.nvm/nvm.sh"

( ( cd ../codecombat ; sudo -u "$user" npm start ; ) 1>codecombat.log 2>codecombat.log ; ) &
echo -n $! >codecombat.pid
