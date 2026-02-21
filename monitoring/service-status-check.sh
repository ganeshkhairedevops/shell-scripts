#!/bin/bash
SERVICE=$1
if [ -z "$SERVICE" ]; then
    echo "Usage: ./service-status-check.sh <service-name>"
    exit 1
fi
systemctl is-active --quiet $SERVICE
if [ $? -eq 0 ]; then
    echo "$SERVICE is running"
else
    echo "$SERVICE is not running"
fi
