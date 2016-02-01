#!/bin/bash

# from https://github.com/codecombat/codecombat/wiki/Dev-Setup:-Linux#running

if type service 1>>/dev/null 2>>/dev/null
then
  sudo service mongod start
else
  sudo systemctl start mongodb
fi
