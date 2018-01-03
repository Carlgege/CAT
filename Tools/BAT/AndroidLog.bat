@ECHO OFF 
REM Get log
REM Create by Mia
REM 2016.3.4
chcp 950
REM cd /d %~dp0
c:
cd C:\Users\Public\Documents

set par=%1
REM echo %par%
if "%par%" NEQ "" (

set adb="adb -s %par% "
REM echo %adb%

)

:rootConfirm
adb shell ls /data/system/dropbox|find "denied">nul

if %errorlevel% EQU 0 echo Please enable root permission at first && pause && goto rootConfirm

for /f %%i in ('adb shell getprop ro.hardware') do (
set cpuMode=%%i
)

set EXISTS_FLAG=null
echo The cpu type of this device is: %cpuMode%

echo %cpuMode%|find "mt">nul&&set EXISTS_FLAG=mt
echo %cpuMode%|find "qc">nul&&set EXISTS_FLAG=qc
echo %cpuMode%|find "sc">nul&&set EXISTS_FLAG=sc

if "%EXISTS_FLAG%"=="mt" goto mt
if "%EXISTS_FLAG%"=="qc" goto qc
if "%EXISTS_FLAG%"=="sc" goto sc

:mt
REM echo "mtk"
set log_name="mtklog_%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%"
set log_name=%log_name: =0%

echo "抓出mtklog
adb pull /mnt/sdcard/mtklog %log_name%

echo "抓出trace"
adb pull /data/anr %log_name%/anr

echo "抓出data aee db"
adb pull /data/aee_exp %log_name%/data_aee_exp

echo "抓出data mobilelog for 73"
adb pull /data/mobilelog %log_name%/data_mobilelog

echo "抓出NE core"
adb pull /data/core %log_name%/data_core

echo "抓出dropbox"
adb pull /data/system/dropbox %log_name%/dropbox 

echo "抓出tombstones"
adb pull /data/tombstones %log_name%/tombstones 

pause & goto done

:qc
REM echo "qc"
set log_name="QClog_%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%"

mkdir %log_name%
cd %log_name%

mkdir anr
cd anr
adb pull /data/anr
cd ..

mkdir tombstones
cd tombstones
adb pull /data/tombstones
cd ..

mkdir dropbox
cd dropbox
adb pull /data/system/dropbox
cd ..

mkdir last_alog
cd last_alog
adb pull /data/last_alog
cd ..

mkdir last_kmsg
cd last_kmsg
adb pull /data/last_kmsg
cd ..

mkdir alog
cd alog
adb pull /data/logs/alog
adb pull /data/logs/alog.1
adb pull /data/logs/alog.2
adb pull /data/logs/alog.3
adb pull /data/logs/alog.4
adb pull /data/logs/alog.5
adb pull /data/logs/alog.6
adb pull /data/logs/alog_events
adb pull /data/logs/alog_events.1
adb pull /data/logs/alog_events.2
adb pull /data/logs/alog_events.3
adb pull /data/logs/alog_events.4
adb pull /data/logs/alog_events.5
adb pull /data/logs/alog_radio
adb pull /data/logs/alog_radio.1
adb pull /data/logs/alog_radio.2
adb pull /data/logs/alog_radio.3
adb pull /data/logs/alog_radio.4
adb pull /data/logs/alog_radio.5
adb pull /data/logs/alog_system
adb pull /data/logs/alog_system.1
adb pull /data/logs/alog_system.2
adb pull /data/logs/alog_system.3
adb pull /data/logs/alog_system.4
adb pull /data/logs/alog_system.5
cd ..
cd ..

pause & goto done

:sc
REM echo "sc"
md logs
set base_dir="%cd%"
adb pull /data/system/dropbox "%cd%"\logs\dropbox
adb pull /data/tombstones "%cd%"\logs\tombstones
adb pull /data/anr "%cd%"\logs\anr
adb pull /data/slog "%cd%"\logs\interal_slog
adb pull /storage/sdcard0/slog "%cd%"\logs\external_slog
adb shell bugreport >> "%cd%"\logs\bugreport.txt

pause & goto done

:done
