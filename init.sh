#!/bin/bash
set -m

mongodb_cmd="mongod"
cmd="$mongodb_cmd --bind_ip 0.0.0.0 --replSet rs0 --sslMode requireSSL --sslPEMKeyFile /etc/ssl/mongodb.pem"

if [ "$AUTH" == "yes" ]; then
    cmd="$cmd --auth"
fi

if [ "$JOURNALING" == "no" ]; then
    cmd="$cmd --nojournal"
fi

if [ "$OPLOG_SIZE" != "" ]; then
    cmd="$cmd --oplogSize $OPLOG_SIZE"
else
    cmd="$cmd --oplogSize 256"
fi

$cmd &

sleep 60

fg

