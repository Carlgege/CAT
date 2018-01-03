@echo off
adb remount
adb push busybox /system/bin
adb shell chmod 777 /system/bin/busybox
adb shell busybox
pause