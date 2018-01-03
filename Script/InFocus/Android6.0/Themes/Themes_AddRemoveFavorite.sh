source /data/local/tmp/Template.sh

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome

LaunchAP "Themes"
TEXT="";RESOURCEID="com.fihtdc.thememanager:id/icon_container";CLASS="android.widget.LinearLayout";CONTENTDESC="";INSTANCE="1"
ClickIntelligent
Wait 1000

for i1 in $(busybox seq 300)
do
echo `DATE` ${0##*/} Current Time is:$i1>>$DetailLog
#Please add operation on below
TEXT="";RESOURCEID="com.fihtdc.thememanager:id/action_favorite";CLASS="android.widget.TextView";CONTENTDESC="Favorite";INSTANCE="1"
ClickIntelligent
Wait 1000

TEXT="";RESOURCEID="com.fihtdc.thememanager:id/action_favorite";CLASS="android.widget.TextView";CONTENTDESC="Favorite";INSTANCE="1"
ClickIntelligent
#Wait 1000
done

done
LogPass

Back_key
Back_key
Back_key
