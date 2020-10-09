#!/usr/bin/env bash

set -e
set -u

db_endpoint="$(grep "external\\_.*\\_database\\_address" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_username="$(grep "external\\_.*\\_database\\_username" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_password="$(grep "external\\_.*\\_database\\_password" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"

databases="$(grep "external\\_.*\\_database\\_name" "vars-store/$VARS_STORE_FILE" | awk '{print $2}')"

#Create tunnel to MYSQL instance via soho
jumpbox_key="$(mktmp)"
echo -e $JUMPBOX_KEY > $jumpbox_key
chmod 0600 $jumpbox_key
eval `ssh-agent`
ssh-add  $jumpbox_key

ssh "3306:$db_endpoint:3306 $JUMPBOX -N -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no &"

sleep 5

for db_name in $databases; do
  echo "Creating $db_name"
  MYSQL_PWD="$db_password" mysql -h 127.0.0.1 -u"$db_username" -e "create database if not exists \`$db_name\`;"
  sleep 0.1
done
