#!/usr/bin/env sh
cd `dirname $0`

# Compile all required projects...
#(cd ..; make compile)

# Start Nitrogen on Inets...
echo "Starting Nitrogen on Yaws (http://localhost:8000)..."
erl \
    -name nitrogen@127.0.0.1 \
    -pa ./ebin ../apps/*/ebin ../apps/*/include \
    -s make all \
    -eval "application:start(mnesia)" \
    -eval "application:start(mprocreg)" \
    -eval "application:start(quickstart_yaws)"
