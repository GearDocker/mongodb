#!/bin/bash
set -m

mongodb_cmd="mongod"
cmd="$mongodb_cmd --bind_ip 0.0.0.0 --replSet rs0 --sslMode requireSSL --sslPEMKeyFile /etc/ssl/mongodb.pem"

#mongod --port 27017 --dbpath /srv/mongodb/db0 --replSet rs0 --bind_ip localhost,<ip address of the mongod host>

if [ "$AUTH" == "yes" ]; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "no" ]; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
fi

$cmd &

sleep 60
/set_mongodb_password.sh

#if [ ! -f /data/db/.mongodb_password_set ]; then
#    /set_mongodb_password.sh
#fi

fg

