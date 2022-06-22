################################################################################################
# This script is used to check a computer or server availability.                              #
# Editor : Christopher Mogis                                                                   #
# Date : 06/03/2022                                                                            #
# Version 1.0                                                                                  #
################################################################################################

#Function create Log folder
 Function CreateLogsFolder
{
    If(!(Test-Path C:\Logs))
    {
    New-Item -Force -Path "C:\Logs\" -ItemType Directory
		}
		else 
		{ 
    Write-Host "The folder "C:\Logs\" already exists !"
    }
}

#Create Log Folder
 CreateLogsFolder

#Variables
$HDWList = Get-Content C:\Temp\Hardwarelist.txt 
$Date = Get-Date
$Icon = "C:\Users\Default\AppData\Local\ToolScript\favicon-image.ico"
$LogPath = "C:\logs\PingInfra.log"

#Install Favicon
New-Item "C:\Users\Default\AppData\Local\ToolScript" -itemType Directory
$ico = new-object System.Net.WebClient
$ico.DownloadFile("https://raw.githubusercontent.com/ChrisMogis/O365-ManageCalendarPermissions/main/favicon-image.ico","C:\Users\Default\AppData\Local\ToolScript\favicon-image.ico")

#Connectivity Test
foreach ($HDW in $HDWList)

{

$OK = Test-Connection $HDW -Count 1 -Quiet 

if($OK) 
    {

$Response = Test-Connection $HDW -Count 1 | ft Address,IPv4address -HideTableHeaders

    }
    else 
    {

$Failed = Write-Output "$Date : $HDW is not available" | Tee-Object -FilePath $LogPath -Append

#Balloon Notofication
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
$objNotifyIcon = New-Object System.Windows.Forms.NotifyIcon 
$objNotifyIcon.Icon = $Icon
$objNotifyIcon.BalloonTipIcon = "Error"
$objNotifyIcon.BalloonTipTitle = "$HDW" 
$objNotifyIcon.BalloonTipText = "This hardware is not available" 
$objNotifyIcon.Visible = $True 
$objNotifyIcon.ShowBalloonTip(5000)
    }
}
