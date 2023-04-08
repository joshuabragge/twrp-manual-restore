#!/bin/sh

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
# Change if necessary!
localpackages="data/data/"
localapkpath="data/app" # do not append '/'
# Android delivery destination
remotepackages='/data/data/'

if [ -z $1 ]; then
    printf "Usage: %s <pkg-list>\n" $0
    exit 1
fi

printf "=========================================================\n"
printf "Killing ADB server\n"
adb kill-server
printf "Starting ADB server with sudo\n"
sudo adb start-server
printf "Starting ADB as root\n"
adb root
printf "=========================================================\n"

function restore_pkg()
{
    package=$1
    if [ -z $package ]; then
        return
    fi

    printf "=========================================================\n"

    adb shell pm path $package
    exists=$?

    if [ $exists -eq 0 ]; then
        printf "Killing %s\n" $package
        adb shell am force-stop $package
        printf "Clearing %s\n" $package
        adb shell pm clear $package
    fi

    printf "Reinstalling apk of %s\n" $package
    apkpath=$(find -name base.apk -path "*/${package}-*")
    adb install -r "$apkpath"

    if [ $? -ne 0 ] && [ $exists -eq 0]; then
        printf "Package %s is not installed. %s\n" $package
        return
    fi

    printf "Restoring %s\n" $package
    adb push "$localpackages$package" $remotepackages
    printf "Correcting package\n"
    userid=$(adb shell dumpsys package $package | grep userId | cut -d "=" -f2-)
    adb shell chown -R $userid:$userid $remotepackages$package
    adb shell restorecon -Rv $remotepackages$package
    printf "Package restored on device\n"
}

for package in $(cat $1)
do
    restore_pkg $package
    sleep 1
done
