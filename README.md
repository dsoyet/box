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
# build ubuntu
Packer64 build -only linux.vmware-iso.ubuntu matrix
# build windows
Packer64 build -only windows.vmware-iso.desktop matrix
```