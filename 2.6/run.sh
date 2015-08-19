#!/bin/bash
set -m

#ENTRYPOINT ["/usr/local/bin/mongod", "--config", "/config/mongo.yaml"]

mongodb_cmd="mongod"
#cmd="$mongodb_cmd --httpinterface --rest --master"
cmd="$mongodb_cmd --bind_ip 0.0.0.0 --httpinterface --rest --master --sslMode requireSSL --sslPEMKeyFile /etc/ssl/mongodb.pem"

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

if [ ! -f /data/db/.mongodb_password_set ]; then
    /set_mongodb_password.sh
fi

fg

