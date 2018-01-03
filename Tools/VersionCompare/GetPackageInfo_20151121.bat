@echo off
REM Create by Liguo-Chen
REM Phone number: 15105163710
REM EXT: 579-86284
color 0a

title GetPackageInfo

echo          Created by Liguo-Chen
echo.
echo.
echo          Preconditon:
echo.
echo          1. Enable USB debugging from your device
echo.
echo          2. Enable root permission
echo.
echo          3. Install busybox tool
echo.
echo.
echo.
echo          Please press any key to continue && pause>nul 
cls

:choice0
cls
echo.
echo.
echo          1.Get APK version info
echo.
echo          2.Compare APK version info if you need(Mare sure you have performed choice 1)
echo.
echo          3.Pull test result
echo.
echo.
echo.

Set /p a=         Please input(ex:1):
if %a%==1 goto choice1
if %a%==2 goto choice2
if %a%==3 goto choice3

echo.
echo          Input error and press any key to continue & pause>nul
goto choice0


:choice1
cls
echo It will use about 2 minute, running...
echo.
echo.
echo.
adb remount
REM adb shell busybox mount -o remount rw /
REM adb push APPI.txt /mnt/sdcard/ShellResult/VersionCompareResult
REM adb shell busybox dos2unix /mnt/sdcard/ShellResult/VersionCompareResult/APPI.txt
adb shell rm /mnt/sdcard/ShellResult/VersionCompareResult/*
adb push PackageInfo.sh /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
REM adb shell /data/local/tmp/busybox dos2unix /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
REM adb shell chmod 777 /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
adb shell sh /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
echo.
echo.
echo.
echo Completed!
echo Please press any key to continue && pause>nul && goto choice0

:choice2
cls
set /p OldVersionAPKInfo=Please drag the older version's APK info to here:
for %%i in (%OldVersionAPKInfo%) do set filename=%%~nxi
adb push %OldVersionAPKInfo% /mnt/sdcard/ShellResult/VersionCompareResult/%filename%

echo.
echo.
echo.
echo It will use about 2 minute, running...
echo.
echo.
echo.
adb remount
REM adb shell busybox mount -o remount rw /
REM adb push APPI.txt /mnt/sdcard/ShellResult/VersionCompareResult
REM adb shell busybox dos2unix /mnt/sdcard/ShellResult/VersionCompareResult/APPI.txt
adb push PackageInfo.sh /mnt/sdcard/ShellResult/VersionCompareResult
REM adb shell /data/local/tmp/busybox dos2unix /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
REM adb shell chmod 777 /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh
adb shell sh /mnt/sdcard/ShellResult/VersionCompareResult/PackageInfo.sh

echo.
echo.
echo.
echo Completed!
echo Please press any key to continue && pause>nul && goto choice0

:choice3
cls
echo Test Result is below:
adb shell ls /mnt/sdcard/ShellResult/VersionCompareResult/*
adb shell rm /mnt/sdcard/ShellResult/VersionCompareResult/*.sh
adb shell rm /mnt/sdcard/ShellResult/VersionCompareResult/*.txt
adb pull /mnt/sdcard/ShellResult/VersionCompareResult ShellResult
echo.
echo.
echo.
echo Completed!
echo Please press any key to continue && pause>nul && goto choice0

