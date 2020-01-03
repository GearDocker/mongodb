#!/bin/bash

export MONGODB_SET=${MONGODB_SET:=/root/db/.mongodb_set_password}

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

echo "=> Creating an admin user with a $MONGO_PASSWD password in MongoDB"
mongo admin --ssl --sslAllowInvalidCertificates --eval "db.createUser({user: 'admin', pwd: '$MONGO_PASSWD', roles:[{role:'root',db:'admin'}]});"

echo "========================================================================"
echo "You can now connect to this MongoDB server using:"
echo ""
echo "    mongo admin --sslAllowInvalidCertificates --ssl -u admin -p $MONGO_PASSWD --host <host> --port <port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

touch MONGODB_SET
