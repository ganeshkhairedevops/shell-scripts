#!/bin/bash
HOST=$1
PORT=$2
if [ -z "$HOST" ] || [ -z "$PORT" ]; then
    echo "Usage: ./port-check.sh <host> <port>"
    exit 1
fi
nc -zv $HOST $PORT
