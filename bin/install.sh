#!/bin/bash

set -e

if ! type realpath 2>>/dev/null 1>>/dev/null
then
  sudo apt-get install realpath
fi

bin_directory="`dirname \"$0\"`"
bin_directory="`realpath \"$bin_directory\"`"


echo ------------------------------- MongoDB -------------------------------
cd "$bin_directory"


# from https://github.com/codecombat/codecombat/wiki/Dev-Setup:-Linux
if ! type mongod 1>>/dev/null 2>>/dev/null
then
  sudo apt-get -y install mongodb
else
  echo "mongodb is already installed."
fi

if ! sudo apt-get -y install build-essential python2.7 git curl
then
  echo "ERROR: could not install modules."
  exit 1
fi

sudo mkdir -p /data/db
sudo chown -R mongodb /data/db/

echo ------------------------------- node -------------------------------
cd "$bin_directory"

# instead of nodejs-legacy we install a current version
# from https://github.com/niccokunzmann/cp-docker-development/blob/master/docker/docker/zen/setup/01_install.sh

function source_nvm() {
  for s in ~/.bashrc ~/.nvm/nvm.sh ~/.profile
  do
    if [ -f $s ]
    then
      echo -n "source $s ..."
      if source $s
      then
        echo "ok"
      else
        echo "failed"
      fi
    fi
  done
  return 0
}

source_nvm

if ! type nvm 1>>/dev/null 2>>/dev/null
then
  echo ------------------------------- nvm -------------------------------
  echo following the tutorial at
  echo   http://www.nearform.com/nodecrunch/nodejs-sudo-free/
  echo

  curl -q https://raw.githubusercontent.com/creationix/nvm/v0.25.0/install.sh | bash

  source_nvm

  if ! type nvm 1>/dev/null 2>/dev/null
  then
    echo "ERROR: nvm not found"
    nvm
    exit 1
  fi
else
  echo "nvm is installed"
fi

# from https://github.com/creationix/nvm#problems
# installing node from source
if nvm install stable
then
  nvm alias default stable
elif sudo apt-get -y -q install g++ && nvm install -s stable
then
  nvm alias default stable
else
  # from http://oskarhane.com/raspberry-pi-install-node-js-and-npm/
  wget -o ~/.nvm/src/node-v0.10.4.tar.gz http://nodejs.org/dist/v0.10.4/node-v0.10.4-linux-arm-pi.tar.gz
  nvm install 0.10.4
  nvm alias default 0.10.4
fi

nvm use default

npm -g install npm@latest

echo ------------------------------- codecombat -------------------------------
cd "$bin_directory"

npm config set python `which python2.7`

cd ..

if [ -d "codecombat" ]
then
  echo "using local version of codecombat"
  # cd codecombat
  # git pull https://github.com/codecombat/codecombat.git
  # cd ..
else
  git clone --depth=1 --branch=production https://github.com/codecombat/codecombat.git
fi

cd codecombat

echo " - installing codecombat"
echo " - WARNING: make sure you have 1.5 Gigabyte of memory free."

npm install

( cd $( mktemp -d /tmp/coco.XXXXXXXX1 ) && \
  curl http://analytics.codecombat.com:8080/dump.tar.gz | \
    tar xzf - && \
  mongorestore --drop --host 127.0.0.1 )
( cd $( mktemp -d /tmp/coco.XXXXXXXX2 ) && \
  wget https://github.com/cdpoffline/codecombat/releases/download/1/dump.tar.gz && \
  tar xzf dump.tar.gz && \
  mongorestore --drop --host 127.0.0.1 )

echo "!!"
echo "!! You will need to restart the computer"
echo "!!"
