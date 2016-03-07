#!/bin/bash

cd "`dirname \"$0\"`"

if [ -f codecombat.pid ]
then
  if wget -O - http://locahost:3000 >>/dev/null
  then
    echo "codecombat running on port 3000"
    sudo kill -9 `cat codecombat.pid`
    echo "killed codecombat server with pid "`cat codecombat.pid`
  else
    echo "codecombat is not running"
  fi
  rm codecombat.pid
fi

