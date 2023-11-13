if /opt/wait-for-it.sh "$SERVER_NAME:${SERVER_PORT:-27017}" -s -t 30; then
    sleep 2s
    /opt/run.sh
fi
