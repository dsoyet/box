$ProgressPreference = 'SilentlyContinue'
$ErrorActionPreference = 'Stop'

winget source remove msstore 2>&1>$null
winget --version
winget settings --enable LocalManifestFiles | out-null

# $Package = "Microsoft.PowerShell", "Spice.VDAgent", "WireGuard.WireGuard",  "WinFsp.WinFsp", "Git.Git", "Microsoft.VisualStudioCode", "Python.Python.3.13", "Hashicorp.Vagrant", "QL-Win.QuickLook", "OpenVPNTechnologies.OpenVPNConnect", "SumatraPDF.SumatraPDF", "DigitalScholar.Zotero", "Debian.Debian", "Canonical.Ubuntu", "Microsoft.WSL", "OffSec.KaliLinux", "SUSE.openSUSE.Tumbleweed"
# foreach ( $pac in $Package){
#     echo "Install $pac"; winget download $pac
# }
# Invoke-WebRequest https://go.microsoft.com/fwlink/?linkid=2271337 -OutFile adksetup.exe
# .\adksetup.exe

$Package = "PowerShell-7.4.6-win-x64.msi", "spice-vdagent-x64-0.10.0.msi", "wireguard-amd64-0.5.3.msi", "winfsp-2.1.24255.msi", "python-3.13.0-amd64.exe", "vagrant_2.4.1_windows_amd64.msi", "QuickLook-3.7.3.msi", "openvpn-connect-3.5.0.3818_signed.msi"
foreach ( $pac in $Package){
    echo "Install $pac"
    Start-Process -WorkingDirectory "E:\pkg" -FilePath E:\pkg\$pac -ArgumentList '/quiet /norestart' -Wait
}
echo "Install adksetup.exe"
Start-Process -WorkingDirectory "E:\pkg" -FilePath E:\pkg\adksetup.exe -ArgumentList '/installpath "C:\Program Files (x86)\Windows Kits\10" /features OptionId.DeploymentTools /quiet' -Wait

$Package = "Git-2.47.0-64-bit.exe"
foreach ( $pac in $Package){
    echo "Install $pac"
    Start-Process -WorkingDirectory "E:\pkg" -FilePath E:\pkg\$pac -ArgumentList '/VERYSILENT /NORESTART' -Wait
}

cd C:\Windows\System32
echo "Install chezmoi.exe"
tar x -f E:\pkg\chezmoi_2.53.1_windows_amd64.zip chezmoi.exe
echo "Install packer.exe"
tar x -f E:\pkg\packer_1.11.2_windows_amd64.zip  packer.exe

echo "Install wsl.2.1.5.0.x64.msi"
copy E:\pkg\wsl.2.1.5.0.x64.msi C:\Users\vagrant\Downloads
echo "Install Ubuntu2404-240425.AppxBundle"
copy E:\pkg\Ubuntu2404-240425.AppxBundle C:\Users\vagrant\Downloads

echo "Install VSCodeUserSetup-x64-1.94.2.exe"
Start-Process -FilePath E:\pkg\VSCodeUserSetup-x64-1.94.2.exe -ArgumentList '/VERYSILENT /NORESTART /mergetasks=!runcode' -Wait
echo "Install SumatraPDF-3.5.2-64-install.exe"
Start-Process -FilePath E:\pkg\SumatraPDF-3.5.2-64-install.exe -ArgumentList '-install -s' -Wait
echo "Install Zotero-7.0.8_x64_setup.exe"
Start-Process -FilePath E:\pkg\Zotero-7.0.8_x64_setup.exe -ArgumentList '/S' -Wait


Set-Service -Name VirtioFsSvc -StartupType 'Automatic'
