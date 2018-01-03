#!/system/bin/sh
#Create by Liguo-Chen
#Phone number: 15105163710
#EXT: 579-26187
#Update: 2016 02 03

alias busybox="/data/local/tmp/busybox"

#create a folder to shell script result
ShellResult_Folder=/mnt/sdcard/ShellResult/VersionCompareResult
mkdir -p $ShellResult_Folder

#change directory
cd $ShellResult_Folder

#Get DUT info
#PhoneModel=`getprop ro.product.model`
#PhoneVersion=`getprop ro.product.model.num`
AndroidVersion=`getprop ro.build.version.release`
VersionInfo=`cat /system/etc/fver|busybox grep "MLF,"|busybox awk 'BEGIN {FS=","} {print $2}'|busybox awk 'BEGIN {FS="."} {print $1}'`

PKGXLS=`busybox find $ShellResult_Folder -name "PKG*.xls"|busybox wc -l`
if busybox test $PKGXLS -eq 2
then

#Declare files
F1=`ls ${ShellResult_Folder}/PKG*.xls|busybox sed -n 1p`
F2=`ls ${ShellResult_Folder}/PKG*.xls|busybox sed -n 2p`
echo $F1|busybox grep -q $VersionInfo
if busybox test $? -eq 0
then
File1=$F2
File2=$F1
else
File1=$F1
File2=$F2
fi

LineTotal1=`cat $File1|busybox wc -l`
LineTotal2=`cat $File2|busybox wc -l`

LineTotal=$LineTotal1
if busybox test $LineTotal1 -le $LineTotal2
then
LineTotal=$LineTotal2
fi

#Declare a file to save compare result
CompareResultFile=$ShellResult_Folder/PKG_CompareResult.xls
#echo "Feature	Package	CodePath	VersionCode	VersionName	Update?	Feature	Package	CodePath	VersionCode	VersionName">$CompareResultFile
if busybox test -e $CompareResultFile
then
rm $CompareResultFile
fi

repeat=2
while busybox test $repeat -le $LineTotal
do

Package1=`cat $File1|busybox sed -n ${repeat}p|busybox awk '{print $2}'`

if busybox test ! "$Package1" == ""
then

Feature1=`cat $File1|busybox sed -n ${repeat}p|busybox awk '{print $1}'`
CodePath1=`cat $File1|busybox sed -n ${repeat}p|busybox awk '{print $3}'`
VersionCode1=`cat $File1|busybox sed -n ${repeat}p|busybox awk '{print $4}'`
MD5F1=`cat $File1|busybox sed -n ${repeat}p|busybox awk '{print $(NF)}'`
VersionName1=`cat $File1|busybox sed -n ${repeat}p|busybox awk 'BEGIN {FS="\t"} {print $5}'`

FilterTotal=`cat $File2|busybox grep $Package1|busybox wc -l`
FilterNum=1
if busybox test $FilterTotal -gt 1
then
while busybox test $FilterNum -le $FilterTotal
do
FilterPackage=`cat $File2|busybox grep $Package1|busybox sed -n ${FilterNum}p|busybox awk '{print $2}'`
if busybox test "$FilterPackage" == "$Package1"
then
break
fi
let FilterNum=FilterNum+1
done
fi

VersionName2=`cat $File2|busybox grep $Package1|busybox sed -n ${FilterNum}p|busybox awk 'BEGIN {FS="\t"} {print $5}'`
VersionCode2=`cat $File2|busybox grep $Package1|busybox sed -n ${FilterNum}p|busybox awk '{print $4}'`
MD5F2=`cat $File2|busybox grep $Package1|busybox sed -n ${FilterNum}p|busybox awk '{print $(NF)}'`

cat $File2|busybox grep -q $Package1
if busybox test $? -eq 0
then

if busybox test "$MD5F1" == "$MD5F2"
then
echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	MD5 Same	$Package1	$Feature1	$CodePath1	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile
else
#echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	Update	$Package1	$Feature1	$CodePath1	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile
if busybox test "$VersionName1" == "$VersionName2"
then
echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	Version Same	$Package1	$Feature1	$CodePath1	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile
else

echo $VersionName1|busybox grep -q "$AndroidVersion"
if busybox test $? -eq 0
then
echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	Platform Same	$Package1	$Feature1	$CodePath1	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile
else
echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	Update	$Package1	$Feature1	$CodePath1	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile
fi

fi

fi

else
echo "$Package1	$Feature1	$CodePath1	$VersionCode1	$VersionName1	$MD5F1	Removed		 	 	 	 	 ">>$CompareResultFile

fi
fi




Package2=`cat $File2|busybox sed -n ${repeat}p|busybox awk '{print $2}'`

if busybox test ! "$Package2" == ""
then

Feature2=`cat $File2|busybox sed -n ${repeat}p|busybox awk '{print $1}'`
CodePath2=`cat $File2|busybox sed -n ${repeat}p|busybox awk '{print $3}'`
VersionCode2=`cat $File2|busybox sed -n ${repeat}p|busybox awk '{print $4}'`
VersionName2=`cat $File2|busybox sed -n ${repeat}p|busybox awk 'BEGIN {FS="\t"} {print $5}'`
MD5F2=`cat $File2|busybox sed -n ${repeat}p|busybox awk '{print $(NF)}'`

FilterTotal=`cat $File1|busybox grep $Package2|busybox wc -l`
FilterNum=1
if busybox test $FilterTotal -gt 1
then
while busybox test $FilterNum -le $FilterTotal
do
FilterPackage=`cat $File1|busybox grep $Package2|busybox sed -n ${FilterNum}p|busybox awk '{print $2}'`
if busybox test "$FilterPackage" == "$Package2"
then
break
fi
let FilterNum=FilterNum+1
done
fi

MD5F1=`cat $File1|busybox grep $Package2|busybox sed -n ${FilterNum}p|busybox awk '{print $(NF)}'`
VersionName1=`cat $File1|busybox grep $Package2|busybox sed -n ${FilterNum}p|busybox awk 'BEGIN {FS="\t"} {print $5}'`
VersionCode1=`cat $File1|busybox grep $Package2|busybox sed -n ${FilterNum}p|busybox awk '{print $4}'`

if busybox test ! "$Package2" == "$Package1"
then

cat $File1|busybox grep -q $Package2
if busybox test $? -eq 0
then

if busybox test "$MD5F1" == "$MD5F2"
then
echo "$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2	MD5 Same	$Package2	$Feature2	$CodePath2	$VersionCode1	$VersionName1	$MD5F1">>$CompareResultFile
else
#echo "$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2	Update	$Package2	$Feature2	$CodePath2	$VersionCode1	$VersionName1	$MD5F1">>$CompareResultFile

if busybox test "$VersionName1" == "$VersionName2"
then
echo "$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2	Version Same	$Package2	$Feature2	$CodePath2	$VersionCode1	$VersionName1	$MD5F1">>$CompareResultFile
else

echo $VersionName2|busybox grep -q "$AndroidVersion"
if busybox test $? -eq 0
then
echo "$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2	Platform Same	$Package2	$Feature2	$CodePath2	$VersionCode1	$VersionName1	$MD5F1">>$CompareResultFile
else
echo "$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2	Update	$Package2	$Feature2	$CodePath2	$VersionCode1	$VersionName1	$MD5F1">>$CompareResultFile
fi

fi

fi

else
echo " 	 	 	 	 		Added	$Package2	$Feature2	$CodePath2	$VersionCode2	$VersionName2	$MD5F2">>$CompareResultFile

fi

fi

fi

let repeat=repeat+1
done

#Final result
eval File3=`echo $File1|busybox awk 'FS="/" {print $NF}'|busybox sed 's/.xls//g'`
eval File4=`echo $File2|busybox awk 'FS="/" {print $NF}'|busybox sed 's/.xls//g'`
FinalCompareResult=VersionCompare_${File3}_${File4}.xls
FinalCompareResult=${FinalCompareResult//PKGInfo_/}
FinalCompareResult=${ShellResult_Folder}/${FinalCompareResult}
VSResult=VS_${File3}_${File4}.xls
VSResult=${VSResult//PKGInfo_/}
VSResult=${ShellResult_Folder}/${VSResult}

if test -e $VSResult
then
rm $VSResult
fi

echo "${File3//PKGInfo_/}							${File4//PKGInfo_/}				">$FinalCompareResult
echo "Package	Feature	CodePath	VersionCode	VersionName	MD5	Update?	Package	Feature	CodePath	VersionCode	VersionName	MD5">>$FinalCompareResult
cat $CompareResultFile|busybox sort -k 2|busybox uniq>>$FinalCompareResult
rm $CompareResultFile

removeSameNumber=1
removeSameTotal=`cat $FinalCompareResult|busybox wc -l`
while busybox test $removeSameNumber -le $removeSameTotal
do
preLineFirstValue=`cat $FinalCompareResult|busybox sed -n ${removeSameNumber}p|busybox awk '{print $1}'`
let nextLineNumber=removeSameNumber+1
nextLineFirstValue=`cat $FinalCompareResult|busybox sed -n ${nextLineNumber}p|busybox awk '{print $1}'`
preLineFirstValue1=`echo $preLineFirstValue|busybox sed -n '/[[:alpha:]]/p'`

#echo $preLineFirstValue $nextLineFirstValue $preLineFirstValue1

if busybox test "$preLineFirstValue" == "$preLineFirstValue1"
then
if busybox test ! "$preLineFirstValue" == "$nextLineFirstValue"
then
cat $FinalCompareResult|busybox sed -n ${removeSameNumber}p >>$VSResult
else
cat $FinalCompareResult|busybox sed -n ${removeSameNumber}p >>$VSResult
let removeSameNumber=removeSameNumber+1
fi
else
cat $FinalCompareResult|busybox sed -n ${removeSameNumber}p >>$VSResult
fi

let removeSameNumber=removeSameNumber+1
#echo $removeSameNumber
done

#cat $FinalCompareResult|busybox sed -n ${removeSameTotal}p >>$VSResult
rm $FinalCompareResult
echo Finished!
exit 0

fi






#Declare log file name
AllPKGInfo=$ShellResult_Folder/PKGInfo_"$VersionInfo"_temp.xls

PackageSum=`dumpsys package|busybox fgrep "pkg=Package"|busybox wc -l`
dumpsys package|busybox fgrep "pkg=Package">$ShellResult_Folder/Packages.txt

#echo "Feature	Package	CodePath	VersionCode	VersionName	DataDir	TargetSdk	APPI">$AllPKGInfo
if test -e $AllPKGInfo
then
rm $AllPKGInfo
fi

PackageNum=1

while busybox test $PackageNum -le $PackageSum
do

PackageName=`cat $ShellResult_Folder/Packages.txt|busybox sed -n ${PackageNum}p|busybox awk '{print $2}'`
PackageName=`echo ${PackageName%\}*}`

CodePath=`dumpsys package $PackageName|busybox grep "codePath"|busybox awk 'BEGIN {FS="="} {print $NF}'`
#awk '{print $NF}' will print the last field
Feature=`echo $CodePath|busybox awk 'BEGIN {FS="/"} {print $NF}'|busybox awk 'BEGIN {FS=".apk"} {print $1}'`
#ResourcePath=`dumpsys package $PackageName|busybox grep "resourcePath"|busybox awk 'BEGIN {FS="="} {print $2}'`
VersionCode=`dumpsys package $PackageName|busybox grep "versionCode"|busybox awk 'BEGIN {FS=" "} {print $1}'|busybox awk 'BEGIN {FS="="} {print $2}'`
VersionName=`dumpsys package $PackageName|busybox grep "versionName"|busybox awk 'BEGIN {FS="="} {print $2}'`
DataDir=`dumpsys package $PackageName|busybox grep "dataDir"|busybox awk 'BEGIN {FS="="} {print $2}'`
#TargetSdk=`dumpsys package $PackageName|busybox grep "targetSdk"|busybox awk 'BEGIN {FS="="} {print $3}'`

echo $CodePath|busybox fgrep -q .apk
if busybox test $? -eq 0
then
#if CodePath like /system/app/mms.apk
MD5Value=`busybox md5sum $CodePath|busybox awk '{print $1}'`

else
MD5Value=`busybox md5sum $CodePath/*.*|busybox sed -n 1p|busybox awk '{print $1}'`

fi


#filePath=`busybox find $CodePath -name "*.apk"`
#MD5Value=`busybox md5sum $filePath|busybox awk '{print $1}'`
#if test ! "$CodePath" == ""
#then
#MD5Value=`busybox md5sum $CodePath|busybox awk '{print $1}'`
#else
#CodePath=`busybox find /system -name "${Feature}.apk"`
#MD5Value=`busybox md5sum $CodePath|busybox awk '{print $1}'`
#fi

#APPI=N

#cat $ShellResult_Folder/APPI.txt|busybox grep $PackageName|busybox grep -q $Feature
#if busybox test $? -eq 0
#then
#CompareFeature=`cat $ShellResult_Folder/APPI.txt|busybox grep "$PackageName	"|busybox grep $Feature|busybox awk '{print $1}'`
#if busybox test "$CompareFeature" == "$Feature"
#then
#APPI=Y
#fi
#fi

#echo "$Feature	$PackageName	$CodePath	$VersionCode	$VersionName	$DataDir	$MD5Value	$APPI">>$AllPKGInfo
echo "$Feature	$PackageName	$CodePath	$VersionCode	$VersionName	$DataDir	$MD5Value">>$AllPKGInfo

PackageNum=`busybox expr $PackageNum + 1`
done

#Declare log file name
AllPKGInfo2=$ShellResult_Folder/PKGInfo_"$VersionInfo".xls
echo "Feature	Package	CodePath	VersionCode	VersionName	DataDir	MD5Value">$AllPKGInfo2
cat $AllPKGInfo|busybox sort >> $AllPKGInfo2
rm $AllPKGInfo

rm $ShellResult_Folder/Packages.txt

