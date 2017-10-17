#!/bin/bash

PASS=${MONGO_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MONGO_PASS} ] && echo "preset" || echo "random" )

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo --ssl admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating an admin user with a ${_word} password in MongoDB"
mongo admin --ssl --eval "db.createUser({user: 'admin', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"

echo "=> Done!"
touch /data/db/.mongodb_password_set

echo "========================================================================"
echo "You can now connect to this MongoDB server using:"
echo ""
echo "    mongo admin --ssl -u admin -p $PASS --host <host> --port <port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"
