#!/bin/bash

set -e

cd "`dirname \"$0\"`"

cd ..

# install phantomjs
if ! type phantomjs 2>>/dev/null 1>>/dev/null
then
  if ! sudo apt-get -y -qq install phantomjs
  then
    (
      echo "installing phantomjs"
      cd /tmp
      wget -c -N https://github.com/cdpoffline/phantomjs-linux-armv6l/archive/master.zip
      unzip master.zip
      cd phantomjs-linux-armv6l-master
      tar -zxvf *.tar.gz
      if [ "`./phantomjs-2.0.1-development-linux-armv6l/bin/phantomjs --version`" != "2.0.1-development" ] && ! ./phantomjs-2.0.1-development-linux-armv6l/bin/phantomjs --version
      then
        echo "ERROR: wrong phantomjs!"
        exit 1
      fi
      sudo cp ./phantomjs-2.0.1-development-linux-armv6l/bin/phantomjs /usr/local/bin
    )
  fi
fi

if false #npm install -g phantomjs
then
  echo "installed phantomjs"
elif [ "$HOSTTYPE" != "arm" ]
then
  echo "failed to install phantomjs globally."
else
  echo "Trying again with version of phantomjs for Raspberry Pi."
  rm -r ~/.npm/phantomjs/*
  echo "adding phantomjs to cache"
  npm cache add phantomjs
  dir=/tmp/phantomjs-unpack
  rm -rf $dir
  mkdir -p $dir
  (
    cd $dir
    echo "in `pwd`"
    tar xvzf ~/.npm/phantomjs/*/package.tgz
    if ! [ -f "`type -p phantomjs 2>>/dev/null`" ]
    then
      echo "ERROR: could not find phantomjs file."
      exit 1
    fi
    echo "folders:" `ls` 
    echo "add package binary (should not matter)"
    cp "`type -p phantomjs`" package/bin
    echo "replace version of phantomjs with local one"
    sed -i "s/exports\\.version\\s*=\\s*/exports.version = '`phantomjs --version`' \\/\\/ /g" package/lib/phantomjs.js
    echo "install package"
    npm install package
  )
fi

