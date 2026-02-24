# 📦 Website Backup Automation Script – App Server 3

## 📌 Objective

Create a bash script named `official_backup.sh` on **App Server 3** that:

- Creates a zip archive of `/var/www/html/official`
- Stores it in `/backup/`
- Copies it to Nautilus Backup Server (`stbkp01`)
- Runs without password prompt
- Does not use `sudo` inside the script
- Can be executed by the `banner` user

---

## 🖥 Infrastructure Details

| Server | IP Address | User |
|--------|------------|------|
| App Server 3 | 172.16.238.12 | banner |
| Backup Server | 172.16.238.16 | clint |

---

# login to App Server 3
```bash
ssh banner@172.16.238.12
```

# ⚙ Step 1: Install Required Package

Zip must be installed manually (outside the script).

```bash
sudo yum install -y zip
```

---

# 📁 Step 2: Create Required Directories

```bash
sudo mkdir -p /scripts
sudo mkdir -p /backup
sudo chown banner:banner /scripts
sudo chown banner:banner /backup
```

---

# 🔐 Step 3: Configure Password-less SSH

Generate SSH key (if not already present):

```bash
ssh-keygen -t rsa
```

Copy public key to Backup Server:

```bash
ssh-copy-id clint@172.16.238.16
```
Enter backup server password

Verify password-less access:

```bash
ssh clint@172.16.238.16
```
If no password asked → ✅ correct.

exit back.

---

# 📝 Step 4: Create Backup Script

File location:

`/scripts/official_backup.sh`

Script content:

```bash
#!/bin/bash

# ===============================
# XfusionCorp Official Backup Script
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
```

---

# 🔑 Step 5: Make Script Executable

```bash
chmod +x /scripts/official_backup.sh
```

---

# 🚀 Step 6: Execute Script

```bash
/scripts/official_backup.sh
```

---

# ✅ Verification

### Check Local Backup

```bash
ls -l /backup/
```

### Check Remote Backup Server

```bash
ssh clint@172.16.238.16
ls -l /backup/
```

Archive `xfusioncorp_official.zip` should be present on both servers.

---

# 🕒 Setup Cron (On App Server 3)

Login as banner:
```bash
crontab -e
```
Example: Run daily at 2 AM
```bash
0 2 * * * /scripts/official_backup.sh
```

# 🎯 Final Outcome

✔ Zip archive created  
✔ Saved in `/backup/` on App Server 3  
✔ Copied to `/backup/` on Backup Server  
✔ No password prompt during copy  
✔ No sudo used inside script  
✔ Executable by `banner` user
✔ Set cron

---

