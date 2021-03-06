#!/system/bin/sh
#Created by: Chen liguo
#EXT: 579-26187
#Updated: 2016-02-26

cd /data/local/tmp
PATH=/data/local/tmp:$PATH

ShellResult=/mnt/sdcard/ShellResult

Image=$ShellResult/Image
Memory=$ShellResult/DeviceStatus/Memory
ScriptPath=$ShellResult/ScriptFolder
CpuFreq=$ShellResult/DeviceStatus/CpuFreq
CpuUsage=$ShellResult/DeviceStatus/CpuUsage
BatteryInfo=$ShellResult/DeviceStatus/BatteryInfo
Log=$ShellResult/Log
Temp=$ShellResult/Temp
AttrXMLFile=$Temp/dump

LogFile=$Log/Result.txt
DetailLog=$Log/RunDetail.txt
#JsonResult=$Log/Result.json
#HtmlResult=$Log/result.js
HtmlResult=$Log/TestResult.html
RunningScript=$Temp/RunningScript.txt

CpuFreqLog=$CpuFreq/CpuFreqLog.xls
CpuUsageLog=$CpuUsage/CpuUsageLog.xls
BatteryInfoLog=$BatteryInfo/BatteryInfoLog.xls

#create a folder to store result
mkdir -p $Image
mkdir -p $Memory
mkdir -p $ScriptPath
mkdir -p $CpuFreq
mkdir -p $CpuUsage
mkdir -p $BatteryInfo
mkdir -p $Log
mkdir -p $Temp

touch $LogFile
touch $DetailLog
touch $CpuFreqLog
touch $CpuUsageLog
touch $BatteryInfoLog
touch $RunningScript

alias DATE="date +%Y-%m-%d' '%H:%M:%S"
alias busybox="/data/local/tmp/busybox"

VariableInit()
{
TEXT=DefaultValue
RESOURCEID=DefaultValue
CONTENTDESC=DefaultValue
CLASS=DefaultValue
INSTANCE=1

TEXTTWO=DefaultValue
RESOURCEIDTWO=DefaultValue
CONTENTDESCTWO=DefaultValue
CLASSTWO=DefaultValue
INSTANCETWO=1

#checkable
CHECKABLE=DefaultValue
#checked
CHECKED=DefaultValue
#clickable
CLICKABLE=DefaultValue
#enabled
ENABLED=DefaultValue
#focusable
FOCUSABLE=DefaultValue
#focused
FOCUSED=DefaultValue
#scrollable
SCROLLABLE=DefaultValue
#long-clickable
LONGCLICKABLE=DefaultValue
#password
PASSWORD=DefaultValue
#selected
SELECTED=DefaultValue

}

cur=`dumpsys window|busybox grep init|busybox awk '{print $3}'`
ScreenWidth=`echo ${cur%x*}|busybox sed 's/\([^0-9]\)//g'`
ScreenHeight=`echo ${cur#*x}|busybox sed 's/\([^0-9]\)//g'`

StartRunTime=`date +%s`
EndRunTime=
DurationRunTime=

MonkeyScript()
{
echo "
type=raw events
count= 1
speed= 1.0
start data >>
">$Temp/MonkeyScript
}

TouchDown_monkey()
{
#$1 > x
#$2 > y
#$3 > delay, ms

#MonkeyScript

echo "
captureDispatchPointer(5109520,5109520,0,$1,$2,0,0,0,0,0,0,0)
captureUserWait ( $3 )
">>$Temp/MonkeyScript

#monkey -f $Temp/MonkeyScript 1
}

TouchMove_monkey()
{
#$1 > x
#$2 > y

echo "
captureDispatchPointer(5109520,5109520,2,$1,$2,0,0,0,0,0,0,0)
captureUserWait ( 50 )
">>$Temp/MonkeyScript

}

TouchUp_monkey()
{
#$1 > x
#$2 > y

echo "
captureDispatchPointer(5109520,5109520,1,$1,$2,0,0,0,0,0,0,0)
captureUserWait ( 50 )
">>$Temp/MonkeyScript

}

Power()
{
input keyevent POWER
busybox usleep 300000

echo `DATE`	${0##*/}	Power >> $DetailLog
}

LongPressPower()
{
MonkeyScript

echo "
captureDispatchKey( 0,0,0,26,0,0,0,0)
captureUserWait ( 2000 )
captureDispatchKey( 0,0,1,26,0,0,0,0)
">>$Temp/MonkeyScript

monkey -f $Temp/MonkeyScript 1
KillMonkey
busybox usleep 300000

echo `DATE`	${0##*/}	LongPressPower >> $DetailLog
}

LongPressMenu()
{
MonkeyScript

echo "
captureDispatchKey( 0,0,0,82,0,0,0,0)
captureUserWait ( 2000 )
captureDispatchKey( 0,0,1,82,0,0,0,0)
">>$Temp/MonkeyScript

monkey -f $Temp/MonkeyScript 1
KillMonkey
busybox usleep 300000

echo `DATE`	${0##*/}	LongPressPower >> $DetailLog
}

Menu()
{
input keyevent MENU;busybox usleep 300000
echo `DATE`	${0##*/}	Menu >> $DetailLog
}

Home()
{
input keyevent HOME;busybox usleep 300000
echo `DATE`	${0##*/}	Home >> $DetailLog
}

#Back key and Cancel key are same.
Back()
{
input keyevent BACK;busybox usleep 300000
echo `DATE`	${0##*/}	Back >> $DetailLog
}

Recent()
{
input keyevent KEYCODE_APP_SWITCH
busybox usleep 300000

echo `DATE`	${0##*/}	Recent >> $DetailLog
}

VolumeUp()
{
input keyevent VOLUME_UP;busybox usleep 300000
echo `DATE`	${0##*/}	VolumeUp >> $DetailLog
}

VolumeDown()
{
input keyevent VOLUME_DOWN;busybox usleep 300000
echo `DATE`	${0##*/}	VolumeDown >> $DetailLog
}

Rotate()
{
#$1 > Left/Right/Nature
am instrument -w -e class com.carl.cat.common.Rotate -e Direction $1 com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner
}

#Use hard key to capture screen
Power+VolumeDown()
{

MonkeyScript

echo "
captureDispatchKey(0,0,0,26,0,0,0,0)
captureDispatchKey(0,0,0,25,0,0,0,0)
captureUserWait ( 1300 )
captureDispatchKey(0,0,1,26,0,0,0,0)
captureDispatchKey(0,0,1,25,0,0,0,0)
">>$Temp/MonkeyScript

monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	Catch_screen >> $DetailLog
}

Hook()
{
input keyevent HEADSETHOOK
echo `DATE`	${0##*/}	Hook >> $DetailLog
}

LongPressHook()
{
MonkeyScript

echo "
captureDispatchKey(0,0,0,79,0,0,0,0)
captureUserWait ( 3800 )
captureDispatchKey(0,0,1,79,0,0,0,0)
">>$Temp/MonkeyScript

monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	LongPressHook >> $DetailLog
}

Catch_Log()
{

}

Wait()
{
#$1 > ms
sleepTime=`busybox expr $1 "*" 1000`
busybox usleep $sleepTime

echo `DATE`	${0##*/}	Wait $1 ms >> $DetailLog
}

Click()
{
#MonkeyScript
#TouchDown_monkey $1 $2 0
#TouchUp_monkey $1 $2

#monkey -f $Temp/MonkeyScript 1
input tap $1 $2

echo `DATE`	${0##*/}	Click $1 $2 >> $DetailLog
}

DoubleClick()
{
MonkeyScript
TouchDown_monkey $1 $2 0
TouchUp_monkey $1 $2
TouchDown_monkey $1 $2 0
TouchUp_monkey $1 $2

monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	DoubleClick $1 $2 >> $DetailLog
}

RelativeClick()
{
#$1 > this is one relative coordinate, 1/2 it mean half of screen width
#$2 > this is one relative coordinate, 1/2 it mean half of screen width

#echo $1 $2
#echo coor: ${1%/*} ${1#*/} ${2%/*} ${2#*/}

Click `busybox expr $ScreenWidth "*" ${1%/*} / ${1#*/}` `busybox expr $ScreenHeight "*" ${2%/*} / ${2#*/}`
}

LongPress()
{
MonkeyScript
TouchDown_monkey $1 $2 1200
TouchUp_monkey $1 $2

monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	LongPress $1 $2 >> $DetailLog
}

RelativeLongPress()
{
#$1 > this is one relative coordinate, 1/2 it mean half of screen width
#$2 > this is one relative coordinate, 1/2 it mean half of screen width

LongPress `busybox expr $ScreenWidth "*" ${1%/*} / ${1#*/}` `busybox expr $ScreenHeight "*" ${2%/*} / ${2#*/}`
}

RelativeDoubleClick()
{
#$1 > this is one relative coordinate, 1/2 it mean half of screen width
#$2 > this is one relative coordinate, 1/2 it mean half of screen width

DoubleClick `busybox expr $ScreenWidth "*" ${1%/*} / ${1#*/}` `busybox expr $ScreenHeight "*" ${2%/*} / ${2#*/}`
}

Hold()
{
MonkeyScript
TouchDown_monkey $1 $2 1200

monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	Hold $1 $2 >> $DetailLog
}

Swipe()
{
#input swipe $1 $2 $3 $4 200

#uiautomator runtest CommonAction.jar -c com.fih.liguo.Swipe -e X1 $1 -e Y1 $2 -e X2 $3 -e Y2 $4 -e Step 120
am instrument -w -e class com.carl.cat.common.Swipe -e X1 $1 -e Y1 $2 -e X2 $3 -e Y2 $4 -e Step 120 com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner

busybox usleep 300000

}

Drag()
{
MonkeyScript
TouchDown_monkey $1 $2 1200
TouchMove_monkey $3 $4
TouchUp_monkey $3 $4

monkey -f $Temp/MonkeyScript 1
KillMonkey
}

PinchIn()
{
#$1 > resourceid
#uiautomator runtest CommonAction.jar -c com.fih.liguo.PinchIn -e String $1
am instrument -w -e class com.carl.cat.common.Pinch -e RESOURCEID $1 -e Type in com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner
busybox usleep 300000

}

PinchOut()
{
#$1 > resourceid
#uiautomator runtest CommonAction.jar -c com.fih.liguo.PinchOut -e String $1
am instrument -w -e class com.carl.cat.common.Pinch -e RESOURCEID $1 -e Type out com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner
busybox usleep 300000

}

Notification()
{
#cur=`dumpsys window|busybox grep init|busybox awk '{print $3}'`
#ScreenWidth=`echo ${cur%x*}|busybox sed 's/\([^0-9]\)//g'`
#ScreenHeight=`echo ${cur#*x}|busybox sed 's/\([^0-9]\)//g'`
let x_start=$ScreenWidth/2
let y_start=10
let x_end=$ScreenWidth/2
let y_end=$ScreenHeight-1
input swipe $x_start $y_start $x_end $y_end 200

busybox usleep 300000
echo `DATE`	${0##*/}	Notification >> $DetailLog
}

Get_Current_screen()
{
Current_screen=`dumpsys window windows|busybox fgrep mCurrentFocus|busybox awk '{print $3}'`
Current_screen=`echo ${Current_screen%\\}}`
}

Get_Current_AP()
{
#Get current AP's activity name to Current_AP
Current_AP=`dumpsys window windows|busybox fgrep mFocusedApp|busybox awk '{print $5}'`
#Declare a variable and the value is current ap's package name
Current_AP=`echo ${Current_AP%/*}`
Current_AP=`echo $Current_AP`
}

GetAPUss()
{
Get_Current_AP
#Catch current ap's Uss value to USS.txt
AssignAP=$1
Current_AP=${AssignAP:=$Current_AP}
unset $AssignAP
USS=`procrank|busybox fgrep $Current_AP|busybox sed -n 1p|busybox awk '{print $5}'`
#Read the Uss value from USS.txt, ex: 1888K
Current_AP_Uss=`echo $USS`
#Output the script name that performing, date and time and the USS of current AP to the xls named as current ap's package.
echo "$1	`DATE`	${Current_AP_Uss%K*}" >> $Memory/$Current_AP.xls
}

GetCpuFreq()
{
if test -e /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
then
cpu0Freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq`
else
cpu0Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
then
cpu1Freq=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq`
else
cpu1Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq
then
cpu2Freq=`cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq`
else
cpu2Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
then
cpu3Freq=`cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq`
else
cpu3Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq
then
cpu4Freq=`cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_cur_freq`
else
cpu4Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu5/cpufreq/scaling_cur_freq
then
cpu5Freq=`cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_cur_freq`
else
cpu5Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu6/cpufreq/scaling_cur_freq
then
cpu6Freq=`cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_cur_freq`
else
cpu6Freq=-1
fi

if test -e /sys/devices/system/cpu/cpu7/cpufreq/scaling_cur_freq
then
cpu7Freq=`cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_cur_freq`
else
cpu7Freq=-1
fi

#Cet cpu temp from proc
currentCPUTemp=`cat /proc/driver/thermal/tzcpu_read_temperature|busybox sed -n 1p`
currentCPUTemp=`echo ${currentCPUTemp##*:}`

#If the file is empty then input title
if test "`cat $CpuFreqLog`" -eq ""
then
echo "Time	Cpu0	Cpu1	Cpu2	Cpu3	Cpu4	Cpu5	Cpu6	Cpu7	CurrentCPUTemp">>$CpuFreqLog
fi

echo "`DATE`	$cpu0Freq	$cpu1Freq	$cpu2Freq	$cpu3Freq	$cpu4Freq	$cpu5Freq	$cpu6Freq	$cpu7Freq	$currentCPUTemp" >> $CpuFreqLog

}

GetCpuUsage()
{
#$1 > process number
ProcessNum=$1

TOPTXT=$ShellResult/Temp/TOP.txt
TOPTXT1=$ShellResult/Temp/TOP1.txt
TOPTXT2=$ShellResult/Temp/TOP2.txt

echo "`top -m $ProcessNum -n 1`">$TOPTXT

echo "`busybox sed -n '/,/,1p' $TOPTXT`">$TOPTXT1
#Output from the PID line, start $p line to TOP2.txt
echo "`busybox sed -n '/PID/,$p' $TOPTXT`">$TOPTXT2

#Get CPU usage with User
User=`cat $TOPTXT1|busybox awk '{print $2}'`
User=`echo ${User%\,}`
User=`echo ${User%\%}`

System=`cat $TOPTXT1|busybox awk '{print $4}'`
System=`echo ${System%\,}`
System=`echo ${System%\%}`

IOW=`cat $TOPTXT1|busybox awk '{print $6}'`
IOW=`echo ${IOW%\,}`
IOW=`echo ${IOW%\%}`

IRQ=`cat $TOPTXT1|busybox awk '{print $8}'`
IRQ=`echo ${IRQ%\,}`
IRQ=`echo ${IRQ%\%}`

if test -e $CpuUsageLog
then

if test "cat $CpuUsageLog" -eq ""
then
echo "Time	PID	CPU	VSS	RSS	Name	User	System	IOW	IRQ	SumCPU">>$CpuUsageLog
fi

else
echo "Time	PID	CPU	VSS	RSS	Name	User	System	IOW	IRQ	SumCPU">>$CpuUsageLog

fi

#Declare and inti parameters
Num=2
SumCPU=0
while test $Num -le `busybox expr $ProcessNum + 1`
do

PID=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk '{print $1}'`
CPU=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk '{print $3}'`
CPU=`echo ${CPU%\%}`
VSS=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk '{print $6}'`
VSS=`echo ${VSS/K/}`
RSS=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk '{print $7}'`
RSS=`echo ${RSS/K/}`
Name=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk '{print $NF}'`
#Name=`cat $TOPTXT2|busybox sed -n ${Num}p|busybox awk -v LastColumn=$LastColumn '{print $LastColumn}'`

#Count all cpu value
let SumCPU=CPU+SumCPU

#Output result to log file
#if test $Num -eq `busybox expr $ProcessNum + 1`
if test $Num -eq 2
then
echo "`date +%m-%d-%H-%M-%S`	$PID	$CPU	$VSS	$RSS	$Name	$User	$System	$IOW	$IRQ">>$CpuUsageLog
else
	if test $Num -eq `busybox expr $ProcessNum + 1`
	then
		echo " 	$PID	$CPU	$VSS	$RSS	$Name 	 	 	 	 	$SumCPU">>$CpuUsageLog
	else
		echo " 	$PID	$CPU	$VSS	$RSS	$Name">>$CpuUsageLog
	fi
fi

let Num=Num+1
done

rm $TOPTXT
rm $TOPTXT1
rm $TOPTXT2

}

GetBatteryInfo()
{


}

GetMemoryUsage()
{
dfResult=$Temp/DF.xls
dfTemp=$Temp/dfTemp.txt

if test -e $dfResult
then
echo -n "`DATE`	" > $dfResult
fi

#Get title
for i in $(busybox seq 2 `busybox df|busybox wc -l`)
do
busybox df|busybox sed -n ${i}p
echo $i
done


#busybox df -a >> dfTemp.txt



}

GetHWInfo()
{
#Get SW version
SWVersion=`cat /proc/fver|busybox grep "MLF,"|busybox awk 'BEGIN {FS=","} {print $2}'|busybox awk 'BEGIN {FS="."} {print $1}'`

#Get HW version
HWVersion=`cat /proc/baseband`

#Get Kernel version
KernelVersion=`cat /proc/version`

#Get Cpu info
totalLine=`cat /proc/cpuinfo|busybox wc -l`
CPU=`cat /proc/cpuinfo|busybox sed -n ${totalLine}p|busybox awk -F: '{print $2}'`

#Get Android version
AndroiVersion=`getprop ro.build.version.release`

}

GetDeviceInfo()
{
GetAPUss
GetBattery
GetCPUFreq
GetCPUUsage
GetSignalStrength
}

KillMonkey()
{

monkeyProcessTotal=`busybox ps|busybox grep monkey|busybox grep -v grep|busybox wc -l`
for i in `busybox seq -w 1 $monkeyProcessTotal`
do
monkeyPID=`busybox ps|busybox grep monkey|busybox grep -v grep|busybox sed -n 1p|busybox awk '{print $1}'`

if test ! "$monkeyPID" == ""
then
kill -9 $monkeyPID
fi
done
}

KillProcess()
{
#$1 > process name
#$2 > timeout

for i1 in $(busybox seq $2)
do

processID=`busybox ps|busybox fgrep "$1"|busybox grep -v grep|busybox awk '{print $1}'`
if test "$processID" == ""
then
break
fi
sleep 1

done

if test ! "$processID" == ""
then
kill -9 $processID
fi

}


UpdateXML()
{
#${0##*/} > file name

if test -e $AttrXMLFile
then
rm -rf $AttrXMLFile
busybox usleep 300000
fi

getXMLNum=1
getXMLSum=3
while test $getXMLNum -le $getXMLSum
do

################################
#use default function to get xml
#uiautomator dump $AttrXMLFile&
#busybox usleep 3000000
#echo `DATE`	${0##*/}	UpdateXMLByUiautomatorDump	Times:$getXMLNum >> $DetailLog
#KillProcess uiautomator

#if test -s $AttrXMLFile
#then
#break
#else
#rm $AttrXMLFile
#fi

################################
#use uiautomator dumpWindowHierarchy function to get xml
am instrument -w -e class com.carl.cat.common.GetAttrXML com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner&
#echo `DATE`	${0##*/}	UpdateXMLByDumpWindow	Times:$getXMLNum >> $DetailLog
#busybox usleep 2000000
KillProcess com.android.commands.am.Am 4

if test -s $AttrXMLFile
then
break
else
rm $AttrXMLFile
fi

let getXMLNum++
done

if test ! -e $AttrXMLFile
then
echo `DATE`	${0##*/}	GetAttributionXML	Fail >> $DetailLog
Screenshot
exit
fi

#Kill this function process when it be invoked
#eval 'kill -9 $!'

}

ExistAttributionWithoutUpdateXML()
{
#$1 > attribution
#$2 > instance, default value is: 1

#if the attribution include special character, replace it
attribution="$1"
attribution=`echo $attribution|busybox sed 's/\&/\&amp;/g'`

instance=""
instance=${instance:=$2}
instance=${instance:=1}

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "$attribution"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

let centerX=-1
let centerY=-1

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2

fi
}

ExistAttribution()
{
#$1 > attribution
#$2 > instance, default value is: 1

#if the attribution include special character, replace it
attribution="$1"
attribution=`echo $attribution|busybox sed 's/\&/\&amp;/g'`

instance=""
instance=${instance:=$2}
instance=${instance:=1}

for i in `busybox seq -w 1 2`
do
UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "$attribution"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

let centerX=-1
let centerY=-1

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2

break
fi
done

}

ExistIntelligent()
{

#if the attribution include special character, replace it
TEXT=`echo $TEXT|busybox sed 's/\&/\&amp;/g'`

for i in `busybox seq -w 1 2`
do
UpdateXML

#echo "$TEXT","$RESOURCEID","$CLASS","$CONTENTDESC"

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'`

if test "'$TEXT'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "text=\"$TEXT\""`
fi

if test "'$RESOURCEID'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "resource-id=\"$RESOURCEID\""`
fi

if test "'$CLASS'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "class=\"$CLASS\""`
fi

if test "'$CONTENTDESC'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "content-desc=\"$CONTENTDESC\""`
fi

if test "'$CHECKABLE'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "checkable=\"$CHECKABLE\""`
fi

if test "'$CHECKED'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "checked=\"$CHECKED\""`
fi

if test "'$CLICKABLE'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "clickable=\"$CLICKABLE\""`
fi

if test "'$ENABLED'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "enabled=\"$ENABLED\""`
fi

if test "'$FOCUSABLE'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "focusable=\"$FOCUSABLE\""`
fi

if test "'$FOCUSED'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "focused=\"$FOCUSED\""`
fi

if test "'$SCROLLABLE'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "scrollable=\"$SCROLLABLE\""`
fi

if test "'$LONGCLICKABLE'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "long-clickable=\"$LONGCLICKABLE\""`
fi

if test "'$PASSWORD'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "password=\"$PASSWORD\""`
fi

if test "'$SELECTED'" != "'DefaultValue'"
then
temp=`echo "$temp"|busybox fgrep "selected=\"$SELECTED\""`
fi

temp=`echo "$temp"|busybox sed -n ${INSTANCE}p`

#temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "text=\"$TEXT\""|busybox fgrep "resource-id=\"$RESOURCEID\""|busybox fgrep "class=\"$CLASS\""|busybox fgrep "content-desc=\"$CONTENTDESC\""|busybox sed -n ${INSTANCE}p`

temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

let centerX=-1
let centerY=-1

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2

break
fi
done

}

AttrActionIntelligent()
{
#$1 > Operation type

ExistIntelligent
if test $centerX -ne -1
then

eval $1 $centerX $centerY

echo `DATE`	${0##*/}	$1 $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

else

Screenshot
DurationCount

echo `DATE`	${0##*/}	Fail	$1 $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	$1 $TEXT $RESOURCEID $CONTENTDESC	$INSTANCE >> $DetailLog

#echo AttrAction----TCFailReason: `echo ${1}%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`
#convert space to %20
LogFail `echo ${1}%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`

exit

fi

VariableInit
}

ClickIntelligent()
{
AttrActionIntelligent Click
}

LongPressIntelligent()
{
AttrActionIntelligent LongPress
}

DoubleClickIntelligent()
{
AttrActionIntelligent DoubleClick
}

HoldIntelligent()
{
AttrActionIntelligent Hold
}

DragFrom()
{
ExistIntelligent
if test $centerX -ne -1
then

dragXS=$centerX
dragYS=$centerY

MonkeyScript
TouchDown_monkey $dragXS $dragYS 1400
monkey -f $Temp/MonkeyScript 1
KillMonkey

else

DurationCount
Screenshot

echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

#convert space to %20
LogFail `echo DragIntelligent%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`

exit
fi

VariableInit
}

DragTo()
{
TEXT=$TEXTTWO
RESOURCEID=$RESOURCEIDTWO
CLASS=$CLASSTWO
CONTENTDESC=$CONTENTDESCTWO
INSTANCE=$INSTANCETWO

ExistIntelligent
if test $centerX -ne -1
then

#Drag $dragXS $dragYS $centerX $centerY
MonkeyScript
#TouchDown_monkey $dragXS $dragYS 1200
TouchMove_monkey $centerX $centerY
TouchUp_monkey $centerX $centerY
monkey -f $Temp/MonkeyScript 1
KillMonkey

echo `DATE`	${0##*/}	DragIntelligent		$TEXT	$RESOURCEID	$CONTENTDESC	$INSTANCE	Pass >> $DetailLog

else

DurationCount
Screenshot

echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

#convert space to %20
LogFail `echo DragIntelligent%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`

exit

fi

VariableInit
}

DragIntelligent()
{
#${0##*/} > file name
#$1 > attribution
#$2 > instanceStart, default value is: 1
#$3 > attribution
#$4 > instance, default value is: 1

ExistIntelligent
if test $centerX -ne -1
then

dragXS=$centerX
dragYS=$centerY

#TouchDown $centerX $centerY
MonkeyScript
TouchDown_monkey $centerX $centerY 1200
monkey -f $Temp/MonkeyScript 1
KillMonkey

TEXT=$TEXTTWO
RESOURCEID=$RESOURCEIDTWO
CLASS=$CLASSTWO
CONTENTDESC=$CONTENTDESCTWO
INSTANCE=$INSTANCETWO

ExistIntelligent
if test $centerX -ne -1
then

Drag $dragXS $dragYS $centerX $centerY

echo `DATE`	${0##*/}	DragIntelligent			$TEXT	$RESOURCEID	$CONTENTDESC	$INSTANCE	Pass >> $DetailLog

else

#echo `DATE`	${0##*/}	DragIntelligent			$TEXT	$RESOURCEID	$CONTENTDESC	$INSTANCE	Fail >> $LogFile
#echo `DATE`	${0##*/}	DragIntelligent			$TEXT	$RESOURCEID	$CONTENTDESC	$INSTANCE	Fail >> $DetailLog

Screenshot
DurationCount

echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

#convert space to %20
LogFail `echo DragIntelligent%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`

exit

fi

else

#please add action on here, if the attribution cannot be found, it will be performed

Screenshot
DurationCount

echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

#convert space to %20
LogFail `echo DragIntelligent%20${TEXT}%20${RESOURCEID}%20${CONTENTDESC}%20${INSTANCE}|busybox sed 's/ /%20/g'`

exit

fi

VariableInit
}

SwipeByAttribution()
{
#${0##*/} > file name
#$1 > attribution
#$2 > instance, default value is: 1
#$3 > direction, include: Up/Down/Left/Right

instance=""
instance=${instance:=$2}
instance=${instance:=1}

ExistAttribution "\"$1\"" "$instance"

if test $centerX -ne -1
then

#please add action on here, if the attribution can be found, it will be performed
eval lastParameter=\${$#}

if test "$lastParameter" = "Right"
then

let swipeStartX=p1x+1
let swipeStartY=p2y/2-p1y/2+p1y
let swipeEndX=p2x-1
let swipeEndY=p2y/2-p1y/2+p1y

Swipe $swipeStartX $swipeStartY $swipeEndX $swipeEndY
echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3 >> $DetailLog
fi
if test "$lastParameter" = "Left"
then
let swipeStartX=p2x-1
let swipeStartY=p2y/2-p1y/2+p1y
let swipeEndX=p1x+1
let swipeEndY=p2y/2-p1y/2+p1y

Swipe $swipeStartX $swipeStartY $swipeEndX $swipeEndY
echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3 >> $DetailLog
fi
if test "$lastParameter" = "Down"
then
let swipeStartX=p2x/2-p1x/2+p1x
if test $p1y -le 100
then
let swipeStartY=p1y+100
else
let swipeStartY=p1y+1
fi
let swipeEndX=p2x/2-p1x/2+p1x
let swipeEndY=p2y-1

Swipe $swipeStartX $swipeStartY $swipeEndX $swipeEndY
echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3 >> $DetailLog
fi
if test "$lastParameter" = "Up"
then
let swipeStartX=p2x/2-p1x/2+p1x
let swipeStartY=p2y-1
let swipeEndX=p2x/2-p1x/2+p1x
let swipeEndY=p1y+1

Swipe $swipeStartX $swipeStartY $swipeEndX $swipeEndY
echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3 >> $DetailLog
fi

else

#please add action on here, if the attribution cannot be found, it will be performed
#echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3	Fail >> $LogFile
#echo `DATE`	${0##*/}	SwipeByAttribution	"$1" $3	Fail >> $DetailLog

Screenshot
DurationCount

echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $LogFile
echo `DATE`	${0##*/}	Fail	DragIntelligent $TEXT $RESOURCEID $CONTENTDESC $INSTANCE >> $DetailLog

#convert space to %20
LogFail `echo SwipeByAttribution%20${1}%20${3}%|busybox sed 's/ /%20/g'`

exit
fi

}

FindObjFromListByResourceId()
{
#$1 > ResourceId
#$2 > Text
#$3 > Instance

RESOURCEID="$1"
ExistIntelligent
am instrument -w -e class com.carl.cat.common.FindObjFromListByResourceId -e RESOURCEID $1 -e TEXT `echo "$2"|busybox sed -e "s/ /%20/g"` -e INSTANCE $3 com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner

}

AddWidget()
{
#$1 > widget name
#$2 > instance

instance=""
instance=${instance:=$2}
instance=${instance:=1}
widgetInstance=$instance

Menu
sleep 1

#Click Widget
RESOURCEID="com.fihtdc.foxlauncher:id/menu_item_title"
ClickIntelligent

for i  in `busybox seq 1 11`
do

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox grep "$1"|busybox grep "com.fihtdc.foxlauncher:id/widget_name"|busybox sed -n 1p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

let centerX=-1
let centerY=-1

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2
Click $centerX $centerY
echo `DATE`	${0##*/}	ClickByAttribution	"$1" >> $DetailLog

ExistAttribution "com.fihtdc.foxlauncher:id/second_floor_pane" 1
if test $centerX -ne -1
then

#Click the widget and exit for statement
ClickByResourceId "com.fihtdc.foxlauncher:id/widget_preview" $widgetInstance
echo `DATE`	${0##*/}	ClickByAttribution	"$1" >> $DetailLog

break
else

#exit for statement
break
fi

else

#echo ******* i=$i ***********
if test $i -eq 1
then
for j in `busybox seq 1 11`
do

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "$1"|busybox grep "com.fihtdc.foxlauncher:id/widget_name"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

if test ! "$temp" == ""
then

#please add action on here, if the attribution can be found, it will be performed
break

else

#please add action on here, if the attribution cannot be found, it will be performed
SwipeByAttribution  "com.fihtdc.foxlauncher:id/widgets" 1 "Up"

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "Clock"|busybox grep "com.fihtdc.foxlauncher:id/widget_name"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`
#If device has slide to first widget then break out cycle
if test ! "$temp" == ""
then
break
fi

fi

done
else
SwipeByAttribution  "com.fihtdc.foxlauncher:id/widgets" 1 "Down"
fi

fi

#If the repeat time out of the default value then output Fail to log.
if test $i -eq 11
then
echo `DATE`	${0##*/}	AddWidget "$1" $2	Fail >> $LogFile
echo `DATE`	${0##*/}	AddWidget	"$1" $3	Fail >> $DetailLog
Screenshot
exit
fi

done
echo `DATE`	${0##*/}	AddWidget "$1" $2 >> $DetailLog
}

AddApp()
{
#$1 > app name

Menu
sleep 1

#Click App
ClickByText "App" 1

for i  in `busybox seq 1 6`
do

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "text=\"$1\""|busybox grep "com.fihtdc.foxlauncher:id/icon_title"|busybox sed -n 1p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

let centerX=-1
let centerY=-1

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2
Click $centerX $centerY
echo `DATE`	${0##*/}	ClickByText	"$1" >> $DetailLog
break

else

if test $i -eq 1
then
for j in `busybox seq 1 6`
do

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "text=\"$1\""|busybox grep "com.fihtdc.foxlauncher:id/icon_title"|busybox sed -n 1p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

if test ! "$temp" == ""
then

#please add action on here, if the attribution can be found, it will be performed
break

else

#please add action on here, if the attribution cannot be found, it will be performed
SwipeByAttribution  "com.fihtdc.foxlauncher:id/app" 1 "Up"

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "App Traffic Control"|busybox grep "com.fihtdc.foxlauncher:id/icon_title"|busybox sed -n 1p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`
#If device has slide to first widget then break out cycle
if test ! "$temp" == ""
then
break
fi

fi

done
else
SwipeByAttribution  "com.fihtdc.foxlauncher:id/app" 1 "Down"
fi

fi

#If the repeat time out of the default value then output Fail to log.
if test $i -eq 6
then
echo `DATE`	${0##*/}	AddApp "$1"	Fail >> $LogFile
Screenshot
exit
fi

done

echo `DATE`	${0##*/}	AddApp	"$1" >> $DetailLog
}

#If crash or anr happened close pop up window then stop this script
#crashHandle $$
#$$ is PPID of this script
#Modify the coordinate to suit your device.
CrashHandle()
{
#Kill the process of the AP when force close happened
#kill $(ps| busybox grep com.android.mms | busybox awk '{print $2}')

ErrorString=`dumpsys window|busybox fgrep mCurrentFocus|busybox awk '{print $4}'`
#Declare a variable and the value is current ap's package name
ErrorString=`echo ${ErrorString%/*}`
ErrorString=`echo $ErrorString`

#If DUT pop up force close  window then Click OK to close it.
if test "$ErrorString" == "Error:"
then
Screenshot
#Click OK to close crash window
ClickByAttribution android:id/button1 1
sleep 1
#kill $1
echo "`DATE`	${0##*/}	crash happened" >> $DetailLog
exit
fi

#If DUT pop up anr window then Click OK to close it.
if test "$ErrorString" == "Not"
then
Screenshot
#Click OK to close anr window
ClickByAttribution android:id/button1 1
sleep 1
#kill $1
echo "`DATE`	${0##*/}	anr happened" >> $DetailLog
exit
fi
}

SwitchScreenTo()
{
#$1 > direction, include: Left/Right

#Get screen size at first
#ScreenWidth=`dumpsys input|busybox grep SurfaceWidth|busybox sed 's/\([^0-9]\)//g'`
#ScreenHeight=`dumpsys input|busybox grep SurfaceHeight|busybox sed 's/\([^0-9]\)//g'`

x_start=0
y_start=0
x_end=0
y_end=0

if test $ScreenWidth -lt $ScreenHeight
then
#This is portrait mode
if test "$1" = "Right"
then
#echo $ScreenWidth $ScreenHeight
let x_start=ScreenWidth-1
let y_start=ScreenHeight/2
let x_end=1
let y_end=ScreenHeight/2
#echo $x_start $y_start $x_end $y_end
Swipe $x_start $y_start $x_end $y_end
echo `DATE`	${0##*/}	SwitchScreenTo	"$1" >> $DetailLog
fi

if test "$1" = "Left"
then
#echo $ScreenWidth $ScreenHeight
let x_start=1
let y_start=ScreenHeight/2
let x_end=ScreenWidth-1
let y_end=ScreenHeight/2
#echo $x_start $y_start $x_end $y_end
Swipe $x_start $y_start $x_end $y_end
echo `DATE`	${0##*/}	SwitchScreenTo	"$1" >> $DetailLog
fi

fi
}

Unlock()
{
#No parameter

#Get keyguard attribution
Keyguard=`dumpsys window|busybox grep isStatusBarKeyguard|busybox awk '{print $1}'`
Keyguard=`echo ${Keyguard##*=}`

if test "$Keyguard" == "true"
then
#Get screen on value
Awake=`dumpsys window|busybox grep mAwake|busybox awk '{print $1}'|busybox sed -n 1p`
Awake=`echo ${Awake##*=}`

if test ! "$Awake" == "true"
then

Power
sleep 1

fi

#Get unlock attribution
ExistAttribution "com.android.systemui:id/lock_icon" 1
if test $centerX -ne -1
then

startX=$centerX
startY=$centerY

endX=$startX
endY=10
input swipe $startX $startY $endX $endY
sleep 1

fi

fi

echo `DATE`	${0##*/}	Unlock >> $DetailLog
}

LaunchAP()
{
#$1 > AP name

#if ap's name include '&' then replace it
#apName=$1

#Get APPs from Home screen
CONTENTDESC="Apps"
ClickIntelligent
findAPNum=1
findAPSum=4
while test $findAPNum -le $findAPSum
do
#Find the ap that user want to click
#ExistAttribution "text=\"$1\"" 1
TEXT="$1"
ExistIntelligent
#If find the ap successfully then Click it, else change screen to right screen
if test $centerX -ne -1
then

Click $centerX $centerY
echo `DATE`	${0##*/}	ClickByAttribution	"$1" >> $DetailLog
busybox usleep 300000

#ExistAttribution "Do not show again" 1
#if test $centerX -ne -1
#then
#ClickByAttributionWithoutUpdateXML 'checkbox' 1
#ClickByAttributionWithoutUpdateXML 'text="Agree"' 1
#fi

break
else
SwitchScreenTo Right
fi

let findAPNum++
done

if test $findAPNum -gt $findAPSum
then
echo `DATE`	${0##*/}	LaunchAP $1	Fail >> $DetailLog
Screenshot
exit
fi
}

BackToHome()
{

Unlock
CrashHandle

echo "`DATE`	${0##*/}	$$" >> $RunningScript

Back
Back
Back
Home

echo "`DATE`	${0##*/}	BackToHome" >> $DetailLog
}

DurationCount()
{
let DurationRunTime=EndRunTime-StartRunTime
if test DurationRunTime -gt 86400
then
let DurationDay=DurationRunTime/86400
let DurationHour=DurationRunTime%86400/3600
let DurationMinute=DurationRunTime%86400%3600/60
let DurationSecond=DurationRunTime%86400%3600%60
DurationRunTime=${DurationDay}D${DurationHour}H${DurationMinute}M${DurationSecond}S
elif test DurationRunTime -gt 3600
then
let DurationHour=DurationRunTime/3600
let DurationMinute=DurationRunTime%3600/60
let DurationSecond=DurationRunTime%3600%60
DurationRunTime=${DurationHour}H${DurationMinute}M${DurationSecond}S
elif test DurationRunTime -gt 60
then
let DurationMinute=DurationRunTime/60
let DurationSecond=DurationRunTime%60
DurationRunTime=${DurationMinute}M${DurationSecond}S
else
DurationRunTime=${DurationRunTime}S
fi

}

UpdateDeviceInfo()
{
#ProductName
ProductName=`getprop ro.product.model`

#SN
SN=`getprop ro.serialno`
if test "$SN" == ""
then
SN=0123456789ABCDEF
fi

#SW
SW=`cat /proc/fver|busybox grep "MLF,"|busybox awk 'BEGIN {FS=","} {print $2}'|busybox awk 'BEGIN {FS="."} {print $1}'`

#SKUID
SKUID=`cat /hidden/data/CDALog/ID_Final`

#androidPlatformVersion
androidPlatformVersion=`getprop ro.build.version.release`

#CPUModel
CPUModel=`getprop ro.hardware`

#SIMOperator
SIMOperator=`getprop gsm.sim.operator.alpha`
SIMOperator=,UNICOM
strLen=${#SIMOperator}
if test "$SIMOperator" == ","
then
SIMOperator=NA
elif test "${SIMOperator:0:1}" == ","
then
SIMOperator=${SIMOperator/,/}
elif test "${SIMOperator:$strLen-1:1}" == ","
then
SIMOperator=${SIMOperator/,/}
fi

deviceInfo='var deviceInfo={"ProductName":"'$ProductName'","SN":"'$SN'","SW":"'$SW'","SKUID":"'$SKUID'","androidPlatformVersion":"'$androidPlatformVersion'","CPUModel":"'$CPUModel'","SIMOperator":"'$SIMOperator'"};'
#echo "$deviceInfo"

#deviceInfoRegion=`cat $HtmlResult|busybox fgrep "var deviceInfo"|busybox awk 'FS="=" {print $2}'|busybox sed 's/^ *//g'`
deviceInfoRegion=`cat $HtmlResult|busybox fgrep "var deviceInfo"`
#echo "$deviceInfoRegion"

busybox sed -i "s#$deviceInfoRegion#$deviceInfo#" $HtmlResult

}

UpdateHTMLResult()
{
#$1 > TCDate
#$2 > TCName
#$3 > TCResult
#$4 > TCDuration
#$5 > TCFailReason
#$6 > FailScreenshot


#Get RepeatTimes from detail log
TCRepeat=`cat $DetailLog|busybox fgrep ${0##*/}|busybox grep "Current Time"|busybox tail -1|busybox awk -F: '{print $NF}'`

#convert %20 to space(" ")
TCFailReason=`echo $5|busybox sed -e 's/%20/ /g'`

if test "$TCFailReason" == ""
then
TCFailReason=NA
else
eval TCFailReason='$TCFailReason'
fi

if test "$6" == ""
then
TCFailScreenshot=NA
else
TCFailScreenshot=$6
fi

TCDate=$1
TCName=$2
TCResult=$3
TCDuration=$4

str='{"TCDate":"'$1'","TCName":"'$2'","TCRepeat":"'$TCRepeat'","TCResult":"'$3'","TCDuration":"'$4'","TCFailReason":"'$TCFailReason'","TCFailScreenshot":"'$TCFailScreenshot'","TCPrecondition":"'$TestPrecondition'","TCStep":"'$TestStep'","Creater":"'$Creater'"},'
resultLineNum=`busybox sed -n '/];/=' $HtmlResult|busybox sed -n 1p`
busybox sed -i $resultLineNum'i\'"$str" $HtmlResult

}

LogPass()
{
EndRunTime=`date +%s`
DurationCount
echo `DATE`	${0##*/}	P	$DurationRunTime >> $LogFile

#Output to html
UpdateHTMLResult "`DATE`" ${0##*/} Pass $DurationRunTime
}

LogFail()
{
#$1 > TCFailReason

EndRunTime=`date +%s`
DurationCount

#Output to html
UpdateHTMLResult "`DATE`" ${0##*/} Fail $DurationRunTime "$1" $screenshotFileName
}

Screenshot()
{

screenshotFileName=`date +%Y-%m-%d-%H-%M-%S`
screencap -p $Image/${screenshotFileName}.png

}

DrawPattern()
{
am instrument -w -e class com.carl.cat.common.DrawPattern com.carl.cat.test/android.support.test.runner.AndroidJUnitRunner
}

InputPhoneNumber()
{
#$1 > phone number

#Long press delete button to clear old date
RESOURCEID="com.android.contacts:id/deleteButton"
LongPressIntelligent

numlength=`busybox expr length $1`

for i in `busybox seq 1 $numlength`
do

case `busybox expr substr $1 $i 1` in
0)
	RESOURCEID="com.android.contacts:id/zero"
	ClickIntelligent;;
1)
	RESOURCEID="com.android.contacts:id/one"
	ClickIntelligent;;
2)
	RESOURCEID="com.android.contacts:id/two"
	ClickIntelligent;;
3)
	RESOURCEID="com.android.contacts:id/three"
	ClickIntelligent;;
4)
	RESOURCEID="com.android.contacts:id/four"
	ClickIntelligent;;
5)
	RESOURCEID="com.android.contacts:id/five"
	ClickIntelligent;;
6)
	RESOURCEID="com.android.contacts:id/six"
	ClickIntelligent;;
7)
	RESOURCEID="com.android.contacts:id/seven"
	ClickIntelligent;;
8)
	RESOURCEID="com.android.contacts:id/eight"
	ClickIntelligent;;
9)
	RESOURCEID="com.android.contacts:id/nine"
	ClickIntelligent;;
'#')
	RESOURCEID="com.android.contacts:id/pound"
	ClickIntelligent;;
+)
	RESOURCEID="com.android.contacts:id/zero"
	LongPressIntelligent;;
*)
	RESOURCEID="com.android.contacts:id/star"
	ClickIntelligent;;
esac

done

echo `DATE`	${0##*/}	InputPhoneNumber $1 >> $DetailLog

}

GetTextByAttribution()
{
#$1 > mean attribution
#$2 > mean instance
#$3 > which key

instance=""
instance=${instance:=$2}
instance=${instance:=1}

UpdateXML

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "$1"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`

temp=`echo $temp|busybox awk '{print $3}'`

AttributionValue=

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
#Remove "
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
AttributionValue=`echo ${temp##*=}`
fi

}

DeleteWidget()
{
UpdateXML

delteWidgetNum=0
delteWidgetSum=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "android.appwidget.AppWidgetHostView"|busybox wc -l`
while test $delteWidgetNum -lt $delteWidgetSum
do

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "android.appwidget.AppWidgetHostView"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2

Hold $centerX $centerY
sleep 1
ClickByText 'Remove' 1

fi
let delteWidgetNum++
done

}

DeleteShortcut()
{
UpdateXML

delteWidgetNum=0
delteWidgetSum=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "com.fihtdc.foxlauncher:id/icon_title"|busybox wc -l`
while test $delteWidgetNum -lt $delteWidgetSum
do

temp=`cat $AttrXMLFile|busybox sed 's/>/\n/g'|busybox fgrep "com.fihtdc.foxlauncher:id/icon_title"|busybox sed -n ${instance}p`
temp=`echo ${temp%]\"*}`
temp=`echo $temp|busybox awk '{print $NF}'`

if test ! "$temp" == ""
then
temp=`echo ${temp/bounds=/}`
temp=`echo $temp| busybox sed 's/"//g'| busybox sed 's/\[//g'| busybox sed 's/\]/\n/g'`
p1=`echo $temp|busybox awk '{print $1}'`
p2=`echo $temp|busybox awk '{print $2}'`
p1x=`echo ${p1%,*}`
p1y=`echo ${p1#*,}`
p2x=`echo ${p2%,*}`
p2y=`echo ${p2#*,}`

let centerX=$p1x/2+$p2x/2
let centerY=$p1y/2+$p2y/2

Hold $centerX $centerY
sleep 1
ClickByText 'Remove' 1

fi
let delteWidgetNum++
done
}

UpdateDeviceInfo
VariableInit

Tap()
{
eval $1
ClickIntelligent
}


