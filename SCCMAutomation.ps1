# Site configuration
$SiteCode = "AS1" # Site code 
$ProviderMachineName = "SRVMISCCMCB.asystel.local" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams
function CreateCollection {
    $RootFolder = "SOFTWARE"
    $AppName = Read-Host -Prompt 'Write Appplication Name'

    $UsersCollections = "Users - $AppName - Pilot", "Users - $AppName - Available", "Users - $AppName - Autoinstall"
    $DevicesCollections = "Device - $AppName - Pilot", "Device - $AppName - Available", "Device - $AppName - Autoinstall"
        
    $UsersLimitingCollection = "All Users"
    $DevicesLimitingCollection = "All Systems"

    $RefreshType = "6" #Both
        
    if (-not (Test-Path "Devicecollection\$RootFolder\$AppName")) { New-Item -Path "Devicecollection\$RootFolder" -Name $AppName }
    else { Write-Output "Folder 'Devicecollection\$RootFolder\$AppName' already exist. Skipping..." }

    if (-not (Test-Path "Usercollection\$RootFolder\$AppName")) { New-Item -Path "Usercollection\$RootFolder" -Name $AppName }
    else { Write-Output "Folder 'Usercollection\$RootFolder\$AppName' already exist. Skipping..." }
        
    foreach ($name in $DevicesCollections) {
        if (-not (Get-CMDeviceCollection -Name $name)) {
            try {
                New-CMDeviceCollection -Name $name -LimitingCollectionName $DevicesLimitingCollection -RefreshType $RefreshType | Out-Null
                Write-Output "Collection '$name' created successfully."
                $InputObject = Get-CMDeviceCollection -Name $name
                Move-CMObject -InputObject $InputObject -FolderPath "Devicecollection\$RootFolder\$AppName"
                Write-Verbose "Collection '$name' moved successfully to 'Devicecollection\$RootFolder\$AppName'"
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Output "Error creating device collection. Error message: $ErrorMessage. Failed item: $FailedItem."
            }
        }
        else { Write-Output "Collection '$name' already exist. Skipping..." }
    }

    foreach ($name in $UsersCollections) {
        if (-not (Get-CMUserCollection -Name $name)) {
            try {
                New-CMUserCollection -Name $name -LimitingCollectionName $UsersLimitingCollection -RefreshType $RefreshType | Out-Null
                Write-Output "Collection '$name' created successfully."
                $InputObject = Get-CMUserCollection -Name $name
                Move-CMObject -InputObject $InputObject -FolderPath "Usercollection\$RootFolder\$AppName"
                Write-Verbose "Collection '$name' moved successfully to 'Usercollection\$RootFolder\$AppName'"
            }
            catch {
                $ErrorMessage = $_.Exception.Message
                $FailedItem = $_.Exception.ItemName
                Write-Output "Error creating user collection. Errormessage: $ErrorMessage. Failed item: $FailedItem."
            }
            
        }
        else { Write-Output "Collection '$name' already exist. Skipping..." }
    }
}