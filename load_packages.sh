#!/bin/bash

# The following script will restore apps 
# from a TWRP backup to an android phone.
# Root adb access must be available.

# 1. Extract all the data volumes in the TWRP backup
	# tar -xvf data.ext4.win000
	# tar -xvf data.ext4.win001 etc.
# 2. Turn the bash script into an executable 
	# chmod +x restore_android_packages.sh
# 3. Run script
	# ./restore_android_packages.

# The following resources were used in the creation of this script.
# https://www.semipol.de/2016/07/30/android-restoring-apps-from-twrp-backup.html
# https://itsfoss.com/fix-error-insufficient-permissions-device/

# TWRP extract location for data/data/
localpackages='data/data/'
# Android delivery destination
remotepackages='/data/data/'

# filename of packages in data/data/ to restore
declare -a packages=(
"io.getdelta.android" 
"ca.mogo.mobile"
"au.com.shiftyjelly.pocketcasts"
"com.valvesoftware.android.steam.community"
"com.ubercab"
"de.stocard.stocard"
"com.wealthsimple"
"com.calm.android"
"com.coinomi.wallet"
"com.aspiro.tidal"
"com.appgenix.bizcal"
"com.americanexpress.android.acctsvcs.ca"
"com.amazon.venezia"
)

printf "=========================================================\n"
printf "Killing ADB server\n"
adb kill-server
printf "Starting ADB server with sudo\n"
sudo adb start-server
printf "Starting ADB as root\n"
adb root
printf "=========================================================\n"


for package in ${packages[*]}
do
    printf "=========================================================\n"
    printf "Killing %s\n" $package
    adb shell am force-stop $package
    printf "Clearing %s\n" $package
    adb shell pm clear $package
    printf "Restoring %s\n" $package
    adb push $localpackages$package $remotepackages
    printf "Correcting package\n"
    userid=$(adb shell dumpsys package $package | grep userId | cut -d "=" -f2-)
    adb shell chown -R $userid:$userid $remotepackages$package
    adb shell restorecon -Rv $remotepackages$package
    printf "Package restored on device\n"
    sleep 1
    
done

