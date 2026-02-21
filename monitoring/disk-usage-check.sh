#!/bin/bash
THRESHOLD=80
USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$USAGE" -gt "$THRESHOLD" ]; then
    echo "Disk usage above $THRESHOLD%: $USAGE%"
else
    echo "Disk usage normal: $USAGE%"
fi
