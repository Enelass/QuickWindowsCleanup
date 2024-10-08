@echo off

:: Manual Variable
set banner=This script cleans up disk space
set localadmin=triaustralia\fxb2260
set adminscript=CleanUpDisk.ps1

cd %~dp0\.

::Generated variables
for %%A in ("%adminscript%") do (
    Set folder=%%~dpA
    Set filename=%%~nxA
)
for /F "tokens=* USEBACKQ" %%F in (`hostname`) do (set hostname=%%F)
::set localadmin=%hostname%\Administrator
for /F "tokens=* USEBACKQ" %%F in (`whoami`) do (set user=%%F)
set execbat=elevtemp.bat

::Create sudo
echo @echo Set objShell = CreateObject("Shell.Application") ^> ^%%temp^%%\sudo.tmp.vbs > %temp%\sudo.cmd
echo @echo args = Right("%%*", (Len("%%*") - Len("%%1"))) ^>^> ^%%temp^%%\sudo.tmp.vbs >> %temp%\sudo.cmd
echo @echo objShell.ShellExecute "%%1", args, "", "runas" ^>^> ^%%temp^%%\sudo.tmp.vbs >> %temp%\sudo.cmd
echo @cscript ^%%temp^%%\sudo.tmp.vbs >> %temp%\sudo.cmd

set sudo=%temp%\sudo.cmd

::_____________________________________________________

if not exist %adminscript% (
	echo The script cannot be found !
	echo %adminscript% is missing...
	pause & exit )

md C:\Scripts\ 2> nul
xcopy /Y /H %adminscript% C:\Scripts\
cls


echo %banner%
echo @echo off > C:\Scripts\%execbat%
echo powershell set-executionPolicy unrestricted >> C:\Scripts\%execbat%
echo powershell -file "C:\Scripts\%filename%" >> C:\Scripts\%execbat%
echo ping 0.0.0.0 -n 2 ^> nul  >> C:\Scripts\%execbat%
echo exit 0 >> C:\Scripts\%execbat%

:: Spawn elevated script in user context (As admin)
%sudo% C:\Scripts\%execbat%
exit 0