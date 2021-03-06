#!/bin/bash

set -e

cd "`dirname \"$0\"`"

cd ..

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

# proceeding with the mongodb setup
if ! type mongod
then
  if ! sudo apt-get -y install mongodb-org
  then
    if [ "$1" != "-y" ]
    then
      echo -n "This will take a day to install. Sure, you want to do this? (y/N) "
      read answer
      if [ "$answer" != "y" ]
      then
        exit 1
      fi
    fi
    # from http://c-mobberley.com/wordpress/2013/10/14/raspberry-pi-mongodb-installation-the-working-guide/
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install build-essential libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev scons libboost-all-dev python-pymongo git || { echo "ERROR: could not install modules for mongo db." ; exit 1 ; }
    if ! [ -d "mongo-nonx86" ]
    then
      git clone --depth=1 https://github.com/skrabban/mongo-nonx86.git
    else
      cd mongo-nonx86
      git pull https://github.com/skrabban/mongo-nonx86.git
      cd ..
    fi
    cd mongo-nonx86
    sudo scons || sudo scons
    sudo scons --prefix=/opt/mongo install
    if ! id -u mongodb
    then
      sudo adduser --firstuid 100 --ingroup nogroup --shell /etc/false --disabled-password --gecos "" --no-create-home mongodb
    fi
    sudo mkdir -p /var/log/mongodb/
    sudo chown mongodb:nogroup /var/log/mongodb/
    sudo mkdir -p /var/lib/mongodb
    sudo chown mongodb:nogroup /var/lib/mongodb
    sudo cp debian/init.d /etc/init.d/mongod
    sudo cp debian/mongodb.conf /etc/
    sudo rm -f /usr/bin/mongod
    sudo ln -s /opt/mongo/bin/mongod /usr/bin/mongod
    sudo chmod u+x /etc/init.d/mongod
    sudo update-rc.d mongod defaults
    sudo /etc/init.d/mongod start
    if ! type mongo
    then
      echo "Could not install Mongo db"
      exit 1
    fi
    cd ..
  fi
fi
