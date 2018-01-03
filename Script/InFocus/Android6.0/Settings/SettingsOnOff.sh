source /data/local/tmp/Template.sh

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome

for i1 in $(busybox seq 5000)
do
echo `DATE` ${0##*/} Current Time is:$i1>>$DetailLog
#Please add operation on below
LaunchAP "Settings"
GetMemory

Back_key
Wait 1000

Back_key
Wait 1000

done


done
LogPass
