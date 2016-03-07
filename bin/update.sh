#!/bin/bash

cd "`dirname \"$0\"`"

echo --------- start mongodb ----------

# from https://github.com/codecombat/codecombat/wiki/Dev-Setup:-Linux#running
if type service 1>>/dev/null 2>>/dev/null
then
  sudo service mongod start
else
  sudo systemctl start mongodb
fi
if ! [ "$?" == "0" ]
then
  sudo -u mongodb mongod &
fi

sudo update-rc.d mongodb defaults

echo --------- start server ----------

./start_server.sh

