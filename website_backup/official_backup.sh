#!/bin/bash

# ===============================
# Official Backup Script
# Server: App Server 3
# User: banner
# ===============================

# Full Paths (important for cron)
ZIP_BIN="/usr/bin/zip"
RSYNC_BIN="/usr/bin/rsync"
DATE_BIN="/usr/bin/date"

# Variables
SOURCE="/var/www/html/official"
BACKUP_DIR="/backup"
REMOTE_USER="clint"
REMOTE_HOST="172.16.238.16"
REMOTE_DIR="/backup"
DATE=$($DATE_BIN +%F-%H-%M-%S)
ARCHIVE="xfusioncorp_official_${DATE}.zip"
LOG_FILE="/var/log/official_backup.log"

# Start Logging
echo "=========================================" >> $LOG_FILE
echo "Backup started at $($DATE_BIN)" >> $LOG_FILE

# Check if source directory exists
if [ ! -d "$SOURCE" ]; then
    echo "ERROR: Source directory $SOURCE does not exist!" >> $LOG_FILE
    exit 1
fi

# Create zip archive
$ZIP_BIN -r "$BACKUP_DIR/$ARCHIVE" "$SOURCE" >> $LOG_FILE 2>&1

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create zip archive." >> $LOG_FILE
    exit 1
fi

echo "Zip archive created successfully: $ARCHIVE" >> $LOG_FILE

# Transfer backup to Backup Server using rsync
$RSYNC_BIN -avz "$BACKUP_DIR/$ARCHIVE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/" >> $LOG_FILE 2>&1

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to transfer backup to remote server." >> $LOG_FILE
    exit 1
fi

echo "Backup transferred successfully to $REMOTE_HOST" >> $LOG_FILE
echo "Backup completed at $($DATE_BIN)" >> $LOG_FILE
echo "=========================================" >> $LOG_FILE

exit 0