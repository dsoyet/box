# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables#progresspreference
$ProgressPreference = 'SilentlyContinue'

# PACKER_BUILDER_TYPE vmware-iso

#[System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($PROFILE))
#@"
#`$ProgressPreference = 'SilentlyContinue'
#Set-PSReadLineOption -EditMode Emacs
#"@ | Add-Content $Profile

Write-Host "Crack ..."
Start-Process -FilePath "C:\Windows\System32\dex.cmd" -Wait

$PackageDirectory = "C:\Windows\ConfigSetRoot\Packages\Get"
Set-Location $PackageDirectory
Write-Host "Install Packages ..."

$Computer = Get-CimInstance -ClassName Win32_ComputerSystem
switch ($Computer.Model) {
    "ASUS TUF Gaming F15 FX506HM_FX506HM" {
        Write-Host "Disable Service..."
        $WS = @('ArmouryCrateControlInterface', 'AsusAppService', 'ASUSLinkNear', 'ASUSLinkRemote', 'ASUSOptimization', 'ASUSSoftwareManager', 'ASUSSystemAnalysis', 'ASUSSystemDiagnosis', 'esifsvc', 'igccservice', 'IntelAudioService', 'jhi_service', 'PIEServiceNew', 'RstMwService', 'NVDisplay.ContainerLocalSystem', 'WSearch', 'wuauserv', 'RtkAudioUniversalService')
        $WS.ForEach({
                Write-Host $_
                Get-Service $_ | Stop-Service -PassThru | Set-Service -StartupType Disabled
            })

        Write-Host "Disable Task......"
        $ST = $('ASUS Optimization 36D18D69AFC3', 'ASUS Update Checker 2.0', 'RtkAudUService64_BG')
        $ST.ForEach({
                Write-Host $_
                Unregister-ScheduledTask -TaskName $_ -Confirm:$False
            })
        Write-Host "$(Get-Item Potplayer*).Name"
        Start-Process -FilePath $(Get-Item Potplayer*).Name -ArgumentList '/S /D=C:\Program Files\Potplayer' -Wait
    }
    "VMware7,1" {}
    "TM1801" {
        Write-Host "Disable Service..."
        $WS = @('cphs', 'cplspcon')
        $WS.ForEach({
                Write-Host $_
                Get-Service $_ | Stop-Service -PassThru | Set-Service -StartupType Disabled
            })
    }
}

Write-Host $(Get-Item VSCodeUserSetup-x64-*).Name
Start-Process -FilePath $(Get-Item VSCodeUserSetup-x64-*).Name -ArgumentList '/VERYSILENT /MERGETASKS=!runcode' -Wait
Write-Host $(Get-Item Git-2*).Name
Start-Process -FilePath $(Get-Item Git-2*).Name -ArgumentList '/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS=""' -Wait

$FC = @('115br_*', 'npp.*', 'Zotero-*')
$FC.ForEach({
        Write-Host $(Get-Item $_).Name
        Start-Process -FilePath $(Get-Item $_).Name -ArgumentList '/S -disable-auto-start' -Wait
    })

$MSI = @('putty-64bit-*', 'PowerShell-*')
$MSI.ForEach({
        Write-Host $(Get-Item $_).Name
        Start-Process msiexec.exe -ArgumentList "/qn /i $($(Get-Item $_).Name) /norestart" -Wait
    })

Write-Host $(Get-Item VMware-workstation-full-*).Name
Start-Process -FilePath $(Get-Item VMware-workstation-full-*).Name -ArgumentList '/s /v"/qn EULAS_AGREED=1 SERIALNUMBER="YF390-0HF8P-M81RQ-2DXQE-M2UT6" AUTOSOFTWAREUPDATE=0"' -Wait
Write-Host "vagrant.msi"
Start-Process msiexec.exe -ArgumentList '/qn /i vagrant.msi /norestart INSTALLDIR="C:\Program Files (x86)\HashiCorp\Vagrant"' -Wait
Write-Host "vagrant-vmware-utility.msi"
Start-Process msiexec.exe -ArgumentList '/qn /i vagrant-vmware-utility.msi /norestart INSTALLDIR="C:\Program Files (x86)\HashiCorp\VagrantVMwareUtility"' -Wait

Write-Host $(Get-Item Vivaldi.*).Name
Start-Process -FilePath $(Get-Item Vivaldi.*).Name -ArgumentList '--vivaldi-silent --do-not-launch-chrome' -Wait
Write-Host $(Get-Item 7z*).Name
Start-Process -FilePath $(Get-Item 7z*).Name -ArgumentList '/S /D="C:\Program Files\Sip"' -Wait

Write-Host $(Get-Item SumatraPDF-*).Name
Start-Process -FilePath $(Get-Item SumatraPDF-*).Name -ArgumentList '-s -all-users -with-filter -with-preview' -Wait

$MSI = @('openvpn-connect-*')
$MSI.ForEach({
        Write-Host $(Get-Item $_).Name
        Start-Process msiexec.exe -ArgumentList "/qn /i $($(Get-Item $_).Name) /norestart" -Wait
    })
Start-Process -FilePath Proxy.exe -ArgumentList '/VERYSILENT /NOCANCEL /NORESTART /NOICONS /DIR="C:\Program Files (x86)\Proxy"' -Wait
Write-Host $(Get-Item Nutstore*).Name
Start-Process -FilePath $(Get-Item Nutstore*).Name -ArgumentList '/exenoui /quiet /passive' -Wait
Write-Host $(Get-Item Lark-win32_ia32-*).Name
Start-Process -FilePath $(Get-Item Lark-win32_ia32-*).Name -ArgumentList '--command=quiet_install' -Wait


Write-Host "Dashboard"
$DAC = Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*startglobalproperties\
$HST = "02,00,00,00,08,69,f3,6d,93,e6,d7,01,00,00,00,00,43,42,01,00,02,01,c2,0a,01,c2,14,01,c2,3c,01,c2,46,01,c5,5a,01,00".Split(',') | ForEach-Object { "0x$_" }
Set-ItemProperty -Path "$($DAC.Name[1].replace('HKEY_CURRENT_USER', 'HKCU:'))\Current" -Name Data -Value ([byte[]]$HST)

(New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').items() | Where-Object -Property Name -EQ "Microsoft Edge" | ForEach-Object { ($_).Verbs() | Where-Object { $_.Name.Replace('&', '') -match 'taskbar' } | ForEach-Object { $_.DoIt() } }

Write-Host "Config ..."
C:\Windows\System32\Sip64.exe x ConfigSet.7z -y -oC:\
reg import Registry11.reg

$UserLanguageList = New-WinUserLanguageList -Language "en-US"
$UserLanguageList.Add("zh-CN")
Set-WinUserLanguageList -LanguageList $UserLanguageList -Confirm:$false -Force
# Set-WinSystemLocale -SystemLocale zh-CN

# $WIFI = @('Home.xml', 'Portable.xml', 'Work.xml')
# $WIFI.ForEach({
#         netsh wlan add profile filename=$_ user=all
#     })

Write-Host "Clean System ..."
$ULINK = @('Vivaldi.lnk', '115*', 'Chromium', 'Lark.lnk', 'Visual Studio Code')
$ULINK.ForEach({
        Write-Host $_
        Remove-Item "$Env:AppData\Microsoft\Windows\Start Menu\Programs\$_" -Recurse -Force
    })
$3DO = 'C:\Users\Share\3D Objects'
if (Test-Path -Path $3DO) {
    Remove-Item $3DO -Recurse -Force
}
$EDGE = @('C:\Users\Share\Desktop\Microsoft Edge.lnk', 'C:\Users\Share\Desktop\Chromium.lnk')
$EDGE.ForEach({
        if (Test-Path -Path $_) {
          Remove-Item $_
        }
    })

$PLINK = @('Notepad++.lnk', 'Zotero.lnk', '7-Zip-Zstandard', 'Git', 'Nutstore', 'OpenVPN Connect', 'PuTTY (64-bit)', 'VMware', 'PowerShell')
$PLINK.ForEach({
        Write-Host $_
        Remove-Item "$Env:ProgramData\Microsoft\Windows\Start Menu\Programs\$_" -Recurse -Force
    })
Remove-Item "$Env:ProgramData\Microsoft\Windows\Start Menu\SumatraPDF.lnk" -Recurse -Force

Write-Host "Security ..."
New-NetFirewallRule -Profile Public -DisplayName "Packer Box" -Direction Inbound -Action Allow -Protocol TCP -Program "C:\Windows\System32\Packer64.exe"
New-NetFirewallRule -Profile Public -DisplayName "Packer Box" -Direction Inbound -Action Allow -Protocol UDP -Program "C:\Windows\System32\Packer64.exe"

Set-Location "C:\"
Remove-Item -Force -Recurse -Path "C:\Windows\ConfigSetRoot\*"

$env:Path = "C:\Users\Share\Desktop;$env:Path"

$Computer = Get-CimInstance -ClassName Win32_ComputerSystem
switch ($Computer.Model) {
    "ASUS TUF Gaming F15 FX506HM_FX506HM" {
        Write-Host "System OS Config ..."
        VMwareHorizonOSOptimizationTool.exe -o -t C:\Windows\System32\OVF.xml -firewall disable -windowsupdate disable -antivirus disable -securitycenter disable -f 3 4 5 6 8
        Restart-Computer
    }
    "VMware7,1" {
        Write-Host "System OS Config ..."
        VMwareHorizonOSOptimizationTool.exe -o -t C:\Windows\System32\OVF.xml -firewall disable -windowsupdate disable -antivirus disable -securitycenter disable -f 3 4 5 6 7 8
    }
    "TM1801" {
        Write-Host "System OS Config ..."
    }
}