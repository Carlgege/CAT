source /data/local/tmp/Template.sh

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome

for i1 in $(busybox seq 300)
do
echo `DATE` ${0##*/} Current Time is:$i1>>$DetailLog
#Please add operation on below

LaunchAP "Themes"

TEXT="";RESOURCEID="com.fihtdc.thememanager:id/icon_container";CLASS="android.widget.LinearLayout";CONTENTDESC="";INSTANCE="1"
ClickIntelligent
Wait 1000

TEXT="Applied";RESOURCEID="com.fihtdc.thememanager:id/apply";CLASS="android.widget.Button";CONTENTDESC="";INSTANCE="1"
ExistIntelligent
if test $centerX -ne -1
then
echo exist, do something
Back_key
TEXT="";RESOURCEID="com.fihtdc.thememanager:id/icon_container";CLASS="android.widget.LinearLayout";CONTENTDESC="";INSTANCE="2"
ClickIntelligent

else
echo not exist, do something

fi

TEXT="Apply";RESOURCEID="com.fihtdc.thememanager:id/apply";CLASS="android.widget.Button";CONTENTDESC="";INSTANCE="1"
ClickIntelligent
Wait 5000

Back_key
Wait 1000

Back_key
Wait 1000

Back_key
Wait 5000

Back_key

done

done
LogPass

