#!/bin/bash

export MONGODB_SET=${MONGODB_SET:=/data/db/.mongodb_password_set}

if [ -f $MONGODB_SET ]; then
    echo "mongodb password already set"
    exit 0
fi

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo --ssl admin --sslAllowInvalidCertificates --eval "help" > /dev/null 2>&1
    RET=$?
done

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo --ssl admin --sslAllowInvalidCertificates --eval "help" > /dev/null 2>&1
    RET=$?
done

echo "=> Creating an admin user with a $MONGODB_PASS password in MongoDB"
mongo admin --ssl --sslAllowInvalidCertificates --eval "db.createUser({user: 'admin', pwd: '$MONGODB_PASS', roles:[{role:'root',db:'admin'}]});"

echo "========================================================================"
echo "You can now connect to this MongoDB server using:"
echo ""
echo "    mongo admin --sslAllowInvalidCertificates --ssl -u admin -p $MONGODB_PASS --host <host> --port <port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

touch MONGODB_SET
