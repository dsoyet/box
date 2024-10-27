$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'
# New-VMSwitch -Name "hyperv" -AllowManagementOS $True -NetAdapterName "Ethernet Instance 0"

$edition = (Get-ComputerInfo).WindowsEditionId
switch ($edition) {
    'ServerDatacenter' {
        Install-WindowsFeature Hyper-V -IncludeManagementTools -WarningAction SilentlyContinue
    }
    default {
        Write-Output "$edition"
    }
}

Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -WarningAction SilentlyContinue
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -WarningAction SilentlyContinue