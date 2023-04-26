. $PSScriptRoot\ConnectToSite.ps1

ConnectToSite

function CleanSccm {
    $devices = Get-ADComputer -Filter * -SearchBase "OU=Remove_Device_NOSync,OU=SCCM_Testing,OU=_Central,DC=wittur,DC=com"
    $devicenames = $devices.name
    foreach ($device in $devicenames) {
    Remove-CMDevice -DeviceName $device -Force
    }
}

CleanSCCM