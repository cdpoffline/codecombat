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

echo --------- deactivate ----------

./deactivate.sh

echo --------- activate ----------

# this MUST be the same in deactivate.sh
comment="# start the codecombat server"
rc_local_line="sudo -u mongodb mongod & sudo -u `whoami` \"`pwd`\"/start_server.sh \"$HOME\" $comment"
escaped_rc_local_line="`echo \"$rc_local_line\" | sed -e 's/[\\/\\\\\\&]/\\\\&/g'`"
echo "command: \"$rc_local_line\""
echo "escaped line in /etc/rc.local: \"$escaped_rc_local_line\""
sudo sed -i "s/^exit 0/$escaped_rc_local_line\nexit 0/g" /etc/rc.local

echo "Executing codecombat server"
./start_server.sh
echo "You may want to restart the computer."
