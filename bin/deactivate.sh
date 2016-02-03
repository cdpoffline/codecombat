#!/bin/bash

./stop_server.sh

# this MUST be the same in update.sh
comment="# start the codecombat server"
escaped_text="`echo \"$comment\" | sed -e 's/[\\/\\\\\\&]/\\\\&/g'`"
echo "comment: \"$comment\""
echo "escaped text: \"$escaped_text\""

sudo sed -i "s/^[^\n]*$escaped_text[^\n]*$//g" /etc/rc.local

