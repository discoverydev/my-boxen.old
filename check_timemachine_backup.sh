#!/bin/bash

critMinutes=$1;

if [ "$critMinutes" == "" ]
then
    printf "ERROR - You must provide a critical threshold in minutes!\n"
    exit 1001
fi

# Check to see if we're running Mavericks as Time Machine runs a little differently
osVersion=`sw_vers -productVersion | grep -E -o "[0-9]+\.[0-9]+"`
isMavericks=`echo $osVersion '== 10.9' | bc -l`
isYosemite=`echo $osVersion '== 10.10' | bc -l`
currentDate=`date +%s`

if [ $isMavericks -eq 1 ] || [ $isYosemite -eq 1 ]
then
    # 10.9+ Check
    if [ $isMavericks -eq 1 ]
    then
      printf "Running on Mavericks.\n"
    elif [ $isYosemite -eq 1 ]
    then
      printf "Running on Yosemite.\n"
    fi
    lastBackupDateString=`tmutil latestbackup | grep -E -o "[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6}"`

    if [ "$lastBackupDateString" == "" ]
    then
                printf "Looking for last backup in /Library/Preferences/com.gfi.MaxRMM.TimeMachine.\n"
                lastBackupDateString=`defaults read /Library/Preferences/com.gfi.MaxRMM.TimeMachine LastBackup`
        if [ "$lastBackupDateString" == "" ]
        then
          printf "CRITICAL - Time Machine has not completed a backup on this Mac!\n"
          exit 1002
        fi
    fi

    lastBackupDate=`date -j -f "%Y-%m-%d-%H%M%S" $lastBackupDateString "+%s"`
    `defaults write /Library/Preferences/com.gfi.MaxRMM.TimeMachine LastBackup -string ''$lastBackupDateString''`
else
    # < 10.9 Check
    printf "Running on pre-Mavericks.\n"
    lastBackupDateString=`defaults read /private/var/db/.TimeMachine.Results BACKUP_COMPLETED_DATE`

    if [ "$lastBackupDateString" == "" ]
    then
        printf "CRITICAL - Time Machine has not completed a backup on this Mac!\n"
        exit 1002
    fi

    lastBackupDate=`date -j -f "%Y-%m-%e %H:%M:%S %z" "$lastBackupDateString" "+%s"`
fi


diff=$(($currentDate - $lastBackupDate))
critSeconds=$(($critMinutes * 60))

if [ "$diff" -gt "$critSeconds" ]
then
    printf "CRITICAL - Time Machine has not backed up since `date -j -f %s $lastBackupDate` (more than $critMinutes minutes)!\n"
    exit 1003
fi

if [ "$lastBackupDate" != "" ]
then
    printf "OK - A Time Machine backup has been taken within the last $critMinutes minutes. (`date -j -f %s $lastBackupDate`)\n"
    exit 0
else
    printf "CRITICAL - Could not determine the last backup date for this Mac.\n"
    exit 1002
fi

