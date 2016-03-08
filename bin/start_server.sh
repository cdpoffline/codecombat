#!/bin/bash

cd "`dirname \"$0\"`"

user=`whoami`
if [ -n "$1" ]
then
  user=$1
fi

echo "user $user"

./stop_server.sh

if [ -n "$1" ]
then
  HOME="$1"
fi

sudo -u mongodb bash -c "mongod &"


( 
  sudo -u "$user" bash -c '
    echo "\$HOME $HOME"
    source "$HOME/.nvm/nvm.sh" 
    cd ../codecombat 
    npm start
  ' 1>codecombat.log 2>codecombat.log 
EOF
) &
echo -n $! >codecombat.pid
