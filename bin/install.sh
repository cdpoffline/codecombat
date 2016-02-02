#!/bin/bash

set -e

cd "`dirname \"$0\"`"
where="`pwd`"

source "$where/install_mongodb.sh"
source "$where/install_nvm.sh"
source "$where/install_phantomjs.sh"
source "$where/install_codecombat.sh"
