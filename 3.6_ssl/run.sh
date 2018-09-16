#!/bin/bash

sleep 5

chown -R mongodb:mongodb /etc/ssl
chown -R mongodb:mongodb /etc/mongod.conf

nohup gosu mongodb mongod --dbpath=/data/db &

nohup gosu mongodb mongo admin --eval "help" > /dev/null 2>&1
RET=$?

while [[ "$RET" -ne 0 ]]; do
  echo "Waiting for MongoDB to start..."
  mongo admin --eval "help" > /dev/null 2>&1
  RET=$?
  sleep 2
done

if [ ! -f /data/db/.mongodb_password_set ]; then
    /set_mongodb_password.sh
fi

gosu mongodb mongod --dbpath=/data/db --config mongod.conf --bind_ip_all --auth
