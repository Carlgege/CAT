source /data/local/tmp/Template.sh

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome

LaunchAP "Themes"
Wait 1000

TEXT="";RESOURCEID="";CLASS="android.widget.ImageButton";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="QR Code";RESOURCEID="com.fihtdc.thememanager:id/label";CLASS="android.widget.TextView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="OK";RESOURCEID="android:id/button1";CLASS="android.widget.Button";CONTENTDESC="";INSTANCE="1"
ExistIntelligent
if test $centerX -ne -1
then
echo exist, do something
ClickIntelligent

else
echo not exist, do something

fi

for i2 in $(busybox seq 2)
do
echo `DATE` ${0##*/} Current Time is:$i2>>$DetailLog
#Please add operation on below
TEXT="Allow";RESOURCEID="com.android.packageinstaller:id/permission_allow_button";CLASS="android.widget.Button";CONTENTDESC="";INSTANCE="1"
ExistIntelligent
if test $centerX -ne -1
then
echo exist, do something
TEXT="Allow";RESOURCEID="com.android.packageinstaller:id/permission_allow_button";CLASS="android.widget.Button";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

else
echo not exist, do something

fi

done

for i1 in $(busybox seq 300)
do
echo `DATE` ${0##*/} Current Time is:$i1>>$DetailLog
#Please add operation on below
TEXT="";RESOURCEID="com.fihtdc.qrcode.client.android:id/imageLight";CLASS="android.widget.ImageView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

done

done
LogPass

Back_key
Back_key
Back_key