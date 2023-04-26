#Import Script
. $PSScriptRoot\CreateCollection.ps1
. $PSScriptRoot\ConnectToSite.ps1

ConnectToSite

$AppName = Read-Host -Prompt 'Write Appplication Name'
CreateCollection

