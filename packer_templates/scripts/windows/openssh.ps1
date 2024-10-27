$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

(Get-Content C:\ProgramData\ssh\sshd_config).Replace("Match Group administrators","#Match Group administrators") | Set-Content C:\ProgramData\ssh\sshd_config
(Get-Content C:\ProgramData\ssh\sshd_config).Replace("       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys","#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys") | Set-Content C:\ProgramData\ssh\sshd_config

#pwsh
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShellCommandOption -Value "/c" -PropertyType String -Force

#openssh
Set-NetFirewallRule -DisplayName "OpenSSH SSH Server Preview (sshd)" -Profile Any
Set-Service -Name sshd -StartupType 'Automatic'