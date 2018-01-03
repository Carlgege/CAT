source /data/local/tmp/Template.sh

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome

LaunchAP "Themes"

for i1 in $(busybox seq 300)
do
echo `DATE` ${0##*/} Current Time is:$i1>>$DetailLog
#Please add operation on below

TEXT="";RESOURCEID="";CLASS="android.widget.ImageButton";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="My Theme";RESOURCEID="com.fihtdc.thememanager:id/label";CLASS="android.widget.TextView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="";RESOURCEID="";CLASS="android.widget.ImageButton";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="Theme packs";RESOURCEID="com.fihtdc.thememanager:id/label";CLASS="android.widget.TextView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="FAVORITE";RESOURCEID="com.fihtdc.thememanager:id/tab_title";CLASS="android.widget.TextView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

TEXT="RECENT";RESOURCEID="com.fihtdc.thememanager:id/tab_title";CLASS="android.widget.TextView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

done

done
LogPass

Back_key
Back_key
