$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

# Remote Desktop
New-NetFirewallRule -DisplayName "Remote Desktop (TCP-In)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -RemoteAddress Any -Profile Any -Enabled True 2>&1>$null
New-NetFirewallRule -DisplayName "Remote Desktop (UDP-In)" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 3389 -RemoteAddress Any -Profile Any -Enabled True 2>&1>$null

# ICMP
New-NetFirewallRule -Name 'ICMPv4' -DisplayName 'ICMPv4' -Description 'Allow ICMPv4' -Profile Any -Direction Inbound -Action Allow -Protocol ICMPv4 -Program Any -LocalAddress Any -RemoteAddress Any 2>&1>$null
New-NetFirewallRule -Name 'ICMPv6' -DisplayName 'ICMPv6' -Description 'Allow ICMPv6' -Profile Any -Direction Inbound -Action Allow -Protocol ICMPv6 -Program Any -LocalAddress Any -RemoteAddress Any 2>&1>$null