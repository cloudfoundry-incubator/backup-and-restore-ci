#!/usr/bin/env bash

set -e
set -u

db_endpoint="$(grep "external\\_.*\\_database\\_address" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_username="$(grep "external\\_.*\\_database\\_username" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"
db_password="$(grep "external\\_.*\\_database\\_password" "vars-store/$VARS_STORE_FILE" -m1 | awk '{print $2}')"

databases="$(grep "external\\_.*\\_database\\_name" "vars-store/$VARS_STORE_FILE" | awk '{print $2}')"

for db_name in $databases; do
  echo "Dropping $db_name"
  mysql -h"$db_endpoint" -u"$db_username" -p"$db_password" -e "drop $db_name"
  sleep 0.1
done
