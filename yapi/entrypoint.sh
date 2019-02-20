#!/usr/bin/env bash

./wait-for-it.sh ${YAPI_DB_SERVERNAME}:${YAPI_DB_PORT} -- echo "yapi db is up";

if [! -e "/yapi/init/init.lock"]; then npm run install-server; fi;

node server/app.js;