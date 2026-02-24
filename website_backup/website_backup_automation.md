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

Verify password-less access:

```bash
ssh clint@172.16.238.16
```

---

# 📝 Step 4: Create Backup Script

File location:

`/scripts/official_backup.sh`

Script content:

```bash
#!/bin/bash

SOURCE="/var/www/html/official"
ARCHIVE="xfusioncorp_official.zip"
BACKUP_DIR="/backup"
REMOTE_USER="clint"
REMOTE_HOST="172.16.238.16"
REMOTE_DIR="/backup"

zip -r $BACKUP_DIR/$ARCHIVE $SOURCE
scp $BACKUP_DIR/$ARCHIVE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/
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

# 🎯 Final Outcome

✔ Zip archive created  
✔ Saved in `/backup/` on App Server 3  
✔ Copied to `/backup/` on Backup Server  
✔ No password prompt during copy  
✔ No sudo used inside script  
✔ Executable by `banner` user  

---

# 🔥 Improvement Suggestions (Production Ready)

- Add timestamp to backup file  
- Add logging  
- Add error handling  
- Use `rsync` instead of `scp`  
- Configure cron for automation  
