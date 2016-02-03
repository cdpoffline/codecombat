#!/bin/bash

cd "`dirname \"$0\"`"

if [ -f codecombat.pid ]
then
  sudo kill -9 `cat codecombat.pid`
  echo "killed announcer with pid "`cat codecombat.pid`
  rm codecombat.pid
fi

