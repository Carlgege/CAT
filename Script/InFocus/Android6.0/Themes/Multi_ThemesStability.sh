source /data/local/tmp/Template.sh
cp $ScriptPath/*.sh /data/local/tmp
cd /data/local/tmp
busybox dos2unix *.sh

sh "Themes_AddRemoveFavorite.sh" 1
sh "Themes_ApplyOne.sh" 1
sh "Themes_EnableDisableFlashFromQRCode.sh" 1
sh "Themes_LaunchThemesAfterSwitchTheme.sh" 1
sh "Themes_OnOff.sh" 1
sh "Themes_ScanQRCodeFromPhoto.sh" 1
sh "Themes_SwitchToMyTheme.sh" 1
