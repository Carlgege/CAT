@echo off&setlocal EnableDelayedExpansion
REM Author Liguo Chen
REM extension nubmer:579-86284


echo 1. Make sure your phone has root permission.
echo 2. Make sure your phone has install busybox tool.
echo 3. If you find the last character is "#", it means that this script has completed.
echo 4. Use DDMS or adb command to pull result(one xls file on /data)
echo.
echo.

adb remount
adb push sqlite3 /system/bin
adb shell chmod 777 /system/bin/sqlite3

adb shell chmod 777 /data/MKY_LOG/*

adb push MonkeyAnalyse.sh /data
adb shell busybox dos2unix /data/MonkeyAnalyse.sh
adb shell chmod 777 /data/MonkeyAnalyse.sh
echo cd /data ^^^&^^^& ./MonkeyAnalyse.sh| adb shell

pause