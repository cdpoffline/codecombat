#!/bin/bash

set -e

cd "`dirname \"$0\"`"

echo ------------------------------- MongoDB -------------------------------

# from https://github.com/codecombat/codecombat/wiki/Dev-Setup:-Linux
if ! type mongod 1>>/dev/null 2>>/dev/null
then
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | sudo tee /etc/apt/sources.list.d/mongodb.list
  if ! sudo apt-get update
  then
    sudo rm /etc/apt/sources.list.d/mongodb.list
    sudo apt-get update
  fi
else
  echo "mongodb is already installed."
fi

if ! sudo apt-get -y install build-essential python2.7 git curl
then
  echo "ERROR: could not install modules."
  exit 1
fi

echo ------------------------------- node -------------------------------
cd "`dirname \"$0\"`"

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
cd "`dirname \"$0\"`"

npm config set python `which python2.7`

cd ..

if [ -d "codecombat" ]
then
  cd codecombat
  git pull https://github.com/codecombat/codecombat.git
  cd ..
else
  git clone --depth=1 https://github.com/codecombat/codecombat.git
fi

cd codecombat

npm install

sudo (cd $(mktemp -d /tmp/coco.XXXXXXXX) && curl http://analytics.codecombat.com:8080/dump.tar.gz | tar xzf - && mongorestore --drop --host 127.0.0.1)
