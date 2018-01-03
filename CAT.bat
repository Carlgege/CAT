@echo off & setlocal EnableDelayedExpansion
java
if %errorlevel% EQU 0 cls && echo Your computer does not have java environment, please add it first. && pause && exit
cls
color 0a
echo Do not close this window during you using CAT, otherwise CAT will be closed!

cd jar
java -Dfile.encoding=UTF-8 -jar CAT.jar

pause
