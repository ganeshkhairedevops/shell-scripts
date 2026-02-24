#!/bin/bash

SOURCE="/var/www/html/official"
ARCHIVE="xfusioncorp_official.zip"
BACKUP_DIR="/backup"
REMOTE_USER="clint"
REMOTE_HOST="172.16.238.16"
REMOTE_DIR="/backup"

zip -r $BACKUP_DIR/$ARCHIVE $SOURCE
scp $BACKUP_DIR/$ARCHIVE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/