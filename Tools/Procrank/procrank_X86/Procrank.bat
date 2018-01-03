@echo off
adb remount
adb push procrank /system/bin/
adb shell chmod 777 /system/bin/procrank
adb push libpagemap.so /system/lib/
cls
color 0A
echo This is a test:
ping /n 1 127.1>nul
adb shell procrank

pause