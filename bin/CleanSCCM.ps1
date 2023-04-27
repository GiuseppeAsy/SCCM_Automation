. $PSScriptRoot\..\parameters.ps1
. $PSScriptRoot\ConnectToSite.ps1

ConnectToSite

function CleanSccm {
    $devices = Get-ADComputer -Filter * -SearchBase $CleanOU
    $devicenames = $devices.name
    foreach ($device in $devicenames) {
    Remove-CMDevice -DeviceName $device -Force
    }
}

CleanSCCM