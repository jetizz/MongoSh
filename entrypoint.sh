if /init/wait-for-it.sh "$SERVER_NAME:$SERVER_PORT" -s -t 30; then
    sleep 2s
    /init/run.sh
fi
