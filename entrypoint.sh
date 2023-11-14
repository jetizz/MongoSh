if /var/mongosh/wait-for-it.sh "$SERVER_NAME:${SERVER_PORT:-27017}" -s -t 30; then
    sleep 2s
    /var/mongosh/run.sh
fi
