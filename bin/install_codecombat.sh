#!/bin/bash

set -e

cd "`dirname \"$0\"`"

cd ..

npm config set python `which python2.7`

if ! [ -d "codecombat" ]
then
  git clone --depth=1 https://github.com/codecombat/codecombat.git
else
  cd codecombat
  git pull https://github.com/codecombat/codecombat.git
  cd ..
fi

cd codecombat

npm install

(cd $(mktemp -d /tmp/coco.XXXXXXXX) && curl http://analytics.codecombat.com:8080/dump.tar.gz | tar xzf - && mongorestore --drop --host 127.0.0.1)
