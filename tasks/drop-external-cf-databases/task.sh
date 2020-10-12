#!/usr/bin/env bash
set -euo pipefail

db_endpoint="$(grep "external\\_.*\\_database\\_address" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_username="$(grep "external\\_.*\\_database\\_username" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_password="$(grep "external\\_.*\\_database\\_password" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"

databases="$(grep "external\\_.*\\_database\\_name" "vars-store/$VARS_STORE_FILE" | awk '{print $2}')"

#Create tunnel to MYSQL instance via soho
jumpbox_key="$(mktemp)"
echo -e "$JUMPBOX_KEY" > $jumpbox_key
chmod 0600 $jumpbox_key
eval `ssh-agent`
ssh-add  $jumpbox_key

ssh -L "3306:$db_endpoint:3306" "$JUMPBOX" -N -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no &

sleep 5

for db_name in $databases; do
  echo "Dropping $db_name"
  MYSQL_PWD="$db_password" mysql --host 127.0.0.1 --user "$db_username" --execute "drop database if exists \`$db_name\`;"
  sleep 0.1
done
