source /data/local/tmp/Template.sh

Creater=Carl

TestStep="
1. 
2. 
3. 
"

Repeat=$1
for i in $(busybox seq ${Repeat:-1})
do
echo `DATE` ${0##*/} Current Time is:$i>>$DetailLog
#Please add operation on below
BackToHome



done
LogPass
