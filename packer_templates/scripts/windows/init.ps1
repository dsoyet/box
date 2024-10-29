$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

Stop-Service wuauserv 2>&1>$null
$edition = (Get-ComputerInfo).WindowsEditionId
Write-Output "$edition"
switch ($edition) {
    'ServerDatacenter' {
        Install-WindowsFeature Hyper-V -IncludeManagementTools -WarningAction SilentlyContinue
    }
    'Enterprise' {
        # Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart -WarningAction SilentlyContinue
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart -WarningAction SilentlyContinue
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart -WarningAction SilentlyContinue
    }
    default {
        # Write-Output "$edition"
    }
}


Stop-Service wuauserv 2>&1>$null