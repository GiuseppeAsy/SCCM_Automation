#Import Script
. $PSScriptRoot\bin\CreateCollection.ps1
. $PSScriptRoot\bin\ConnectToSite.ps1

ConnectToSite

$AppName = Read-Host -Prompt 'Write Appplication Name'
CreateCollection

