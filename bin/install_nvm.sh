#!/bin/bash

set -e

cd "`dirname \"$0\"`"

cd ..

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
  echo
  echo -------------------------------------------------------------------------------
  echo install node js
  echo ---------------
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
