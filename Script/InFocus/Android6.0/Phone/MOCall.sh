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

LaunchAP "Phone"

InputPhoneNumber "10010"

TEXT="";RESOURCEID="com.android.contacts:id/dialButton";CLASS="android.widget.ImageView";CONTENTDESC="";INSTANCE="1"
ClickIntelligent

Wait 5000

TEXT="";RESOURCEID="com.android.dialer:id/floating_end_call_action_button";CLASS="android.widget.ImageButton";CONTENTDESC="End";INSTANCE="1"
ClickIntelligent

BackToHome

done

done
LogPass
