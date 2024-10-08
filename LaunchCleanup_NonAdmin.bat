@echo off


:: The script is designed to clean up disk space on a machine by running a PowerShell script with elevated privileges. It sets various variables, generates necessary paths and filenames, and creates a temporary VBScript to run commands with elevated privileges. The script checks if the PowerShell script exists, copies it to a local directory, and temporarily adds the current user to the local Administrators group. It then runs the PowerShell script with elevated privileges and removes the user from the Administrators group afterward. If the user's credentials are incorrect, the script prompts for the correct credentials and retries.
:: Author: Florian Bidabe
:: Date: I don't remember... 10 years ago?

:: Manual Variable
set banner=This script cleans up disk space for Non-Admin
set localadmin=<domain\soeadmin>
set adminscript=<\\NASDrive\CleanUpDisk.ps1>

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


:: Add DOMAIN/USER as Local Admin group (Temporary)
echo %banner%
echo "Enter Domain administrator credentials: "
runas /User:%localadmin% "net localgroup "Administrators" %user% /add" 
if not %ERRORLEVEL% EQU 0 (
 echo Credentials are wrong... Exiting
 ping 0.0.0.0 -n 5 > nul
 exit 1)
cls

:: Right Elevated call and remove from domain admin
echo @echo off > C:\Scripts\%execbat%
echo powershell set-executionPolicy unrestricted >> C:\Scripts\%execbat%
echo net localgroup "Administrators" %user% /delete >> C:\Scripts\%execbat%
echo powershell -file "C:\Scripts\%filename%" >> C:\Scripts\%execbat%
echo ping 0.0.0.0 -n 2 ^> nul  >> C:\Scripts\%execbat%
echo exit 0 >> C:\Scripts\%execbat%

:: Spawn elevated script in user context (As admin)
runas /User:%user% "%sudo% C:\Scripts\%execbat%"
:Auth
if not %ERRORLEVEL% EQU 0 (
 echo Credentials are wrong... Try again !
 runas /User:%user% "%sudo% C:\Scripts\%execbat%"
 goto :Auth)
exit 0