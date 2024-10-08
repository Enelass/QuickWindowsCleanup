#+--------------------------------------------------+   
#+     CleanUp Disk Space							+
#+--------------------------------------------------+  
 
#### Variables #### 
    $objShell = New-Object -ComObject Shell.Application 
    $objFolder = $objShell.Namespace(0xA) 
    $UserTemp = "$env:TEMP"
    $WinTemp = "$env:windir\Temp\*"
	$CTemp = "C:\Temp\*" 
	$OST = "$env:userprofile\AppData\Local\Microsoft\Outlook\*.ost"
	$iTunesB = "$env:userprofile\AppData\Roaming\Apple Computer\MobileSync\Backup\*"
	$ipsw = "$env:userprofile\AppData\Roaming\Apple Computer\iTunes\iPhone Software Updates\*.ipsw"
	
#1# Remove temp directories
    write-Host "Removing Junk files in $UserTemp." -ForegroundColor Cyan  
    Remove-Item -Recurse  "$UserTemp\*" -Force -Verbose 2> null
	ping 0.0.0.0 -n 2 > null
    write-Host "Removing Junk files in $WinTemp." -ForegroundColor Green 
    Remove-Item -Recurse $WinTemp -Force -Verbose 2> null
	write-Host "Removing Junk files in $CTemp." -ForegroundColor Yellow 
    Remove-Item -Recurse $CTemp -Force -Verbose 2> null
	ping 0.0.0.0 -n 2 > null
	
#2# Empty Recycle Bin
    write-Host "Emptying Recycle Bin." -ForegroundColor Cyan  
    $objFolder.items() | %{ remove-item $_.path -Recurse -Confirm:$false} 
	ping 0.0.0.0 -n 2 > null
		
#3# Clear SCCM Cache
	write-Host "Clearing SCCM cache..." -ForegroundColor Cyan
	#Connect to Resource Manager COM Object
	$resman = new-object -com "UIResource.UIResourceMgr"
	$cacheInfo = $resman.GetCacheInfo() ; echo $cacheInfo
	#Enum Cache elements, compare date, and delete older than 15 days
	$cacheInfo.GetCacheElements()  | 
		where-object {$_.LastReferenceTime -lt (get-date).AddDays(-15)} | 
		foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}

#4# Disable hibernation
	write-Host "Disable Hibernation..." -ForegroundColor Cyan
	powercfg -h off
	ping 0.0.0.0 -n 2 > null
	
#5# Running Disk Clean up Tool
    write-Host "Running Windows Disk CleanUp Tool" -ForegroundColor Cyan
	cleanmgr /sagerun:1
	#cleanmgr /sageset:65535 | out-Null
	#cleanmgr /sagerun:65535 | out-Null
     
#6# Enable NTFS Compression
    write-Host "Enable NTFS Compression... (it takes a while)" -ForegroundColor Cyan
	compact "$env:windir\Installer\*" /C /S /A /I
	compact "$env:windir\Assembly\*" /C /S /A /I
	compact "$env:windir\WinSxS\*" /C /S /A /I

#7# Restrict Outlook 2010/2013 OST FileSize
	write-Host "Restrict Outlook OST max filesizeto 5GB" -ForegroundColor Cyan
	Reg.exe add "HKCU\Software\Microsoft\Office\15.0\Outlook\PST" /v "MaxLargeFileSize" /t REG_DWORD /d "5360" /f
	Reg.exe add "HKCU\Software\Microsoft\Office\15.0\Outlook\PST" /v "WarnLargeFileSize" /t REG_DWORD /d "4592" /f
	Reg.exe add "HKCU\Software\Policies\Microsoft\Office\15.0\Outlook\Cached Mode" /v "SyncWindowSetting" /t REG_DWORD /d "3" /f
	Reg.exe add "HKCU\Software\Policies\Microsoft\office\15.0\outlook\cachedmode" /v "CachedExchangeMode" /t REG_DWORD /d "00000001" /f
	Reg.exe add "HKCU\Software\Microsoft\Office\16.0\Outlook\PST" /v "MaxLargeFileSize" /t REG_DWORD /d "5360" /f
	Reg.exe add "HKCU\Software\Microsoft\Office\16.0\Outlook\PST" /v "WarnLargeFileSize" /t REG_DWORD /d "4592" /f
	Reg.exe add "HKCU\Software\Policies\Microsoft\Office\16.0\Outlook\Cached Mode" /v "SyncWindowSetting" /t REG_DWORD /d "3" /f
	Reg.exe add "HKCU\Software\Policies\Microsoft\office\15.0\outlook\cachedmode" /v "CachedExchangeMode" /t REG_DWORD /d "00000001" /f
	taskkill /f /im outlook.exe 2> null ; Remove-Item -Recurse $OST -Force -Verbose 2> null
	
#8# Delete iTunes backups and software updates
	write-Host "Delete iTunes IPSW files (iOS Software Updates)" -ForegroundColor Cyan
	taskkill /f /im itunes.exe 2> null
	Remove-Item -Recurse $ipsw -Force -Verbose 2> null
	Remove-Item -Recurse $iTunesB -Force -Verbose 2> null
		
	write-Host "Cleanup complete ! Exiting..." -ForegroundColor Yellow  
##### End of the Script #####