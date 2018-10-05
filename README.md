# Restore Apps from TWRP Backup

This is a bash script that automates the process of manually restoring android apps from a TWRP backup.
This script was taken from [information provided by semipol.](https://www.semipol.de/2016/07/30/android-restoring-apps-from-twrp-backup.html)

## Doesn't TWRP backups have a restore process?

Well, yes. A TWRP data restore reflashes all your andorid app data /data/data. However, if you just completely wiped your phone during a ROM upgrade or change, you may not want to/ be able to restore all your applications.

This script allows you to semi-automate the manaul restore process, so you can be selective about what applications you restore.

## What does this process look like?

1. Unzip data.ext4 volumes
2. Install app on phone
3. Connects to phone via adb
4. Pushes TWRP app backup /data/data/com.data.app to android app data location /data/data/com.data.app
5. Gets the userId for the app
6. Changes ownership of app data folders to application via the userId
7. Restore the SELinux attributes of the folder
