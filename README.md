## Computer Config (GOOS)
- [Packer](https://developer.hashicorp.com/packer/docs)
- [Ventoy](https://www.ventoy.net/en/doc_news.html)
```
project
│   README.md     
└───example
|   │   *.hcl
└───plugin
    │   config.pkr.hcl
    │   hypervisors.pkr.hcl
    |   linux.pkr.hcl
    │   windows.pkr.hcl

```
### windows
artifacts dir D:\Ventoy\SC
```
project
│   README.md     
└───Ventoy
    │   ventoy.json
    │   ventoy_wimboot.img
```
### linux
### darwin
### android

## Example
```
# build windows
Packer64 build -only windows.vmware-iso.desktop matrix
# vmware-desktop
vagrant plugin install vagrant-vmware-desktop
# build ubuntu
Packer64 build -only linux.vmware-iso.ubuntu matrix
# 
```

## Misc
1. copy [fod packages](https://www.nico-maas.de/?p=2287)

## Math
When $a \ne 0$, there are two solutions to $(ax^2 + bx + c = 0)$ and they are 
$$ x = {-b \pm \sqrt{b^2-4ac} \over 2a} $$

## Snippet
```
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Order>1</Order>
                    <Description>BypassTPMCheck</Description>
                    <Path>cmd /c reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d 1</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>2</Order>
                    <Description>BypassSecureBootCheck</Description>
                    <Path>cmd /c reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d 1</Path>
                </RunSynchronousCommand>
                <RunSynchronousCommand wcm:action="add">
                    <Order>3</Order>
                    <Description>BypassRAMCheck</Description>
                    <Path>cmd /c reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d 1</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
```
```
@echo off
for /f %%D in ('wmic volume get DriveLetter^, Label ^| find "Ventoy"') do set USB=%%D
%USB%\Hardware\VMware\Tools\setup.exe /S /v "/qn REBOOT=R"
pause
```