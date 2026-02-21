#!/bin/bash
HOST=$1
if [ -z "$HOST" ]; then
    echo "Usage: ./ping-check.sh <host>"
    exit 1
fi
ping -c 4 $HOST
