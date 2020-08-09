# ArchLinux Kernel for Microsoft WSL

## Build Kernel
```shell
$ updpkgsums
$ makepkg -s -f
```

## Config
```
1. add NBD Filesystem support
2. add Systemd Hash API support
```

## Mount microsoft VHDX
```shell
$ sudo qemu-nbd -c /dev/nbd0 /mnt/d/Develop/ArchLinux/ext4-extra.vhdx
$ sudo mount -t ext4 -o rw /dev/nbd0 /mnt/media
```

## Compress VHDX
```shell
PS C:\> Optimize-VHD -Path c:\test\dynamic.vhdx -Mode Full
```

## Use Systemd
```
see genie-systemd for more details
```

## Mount Boot from NTFS (drvfs with fstab)
```fstab
# <file system> <dir> <type> <options> <dump> <pass>
D:\Develop\ArchLinux\kernel /boot drvfs rw,noatime
```

## screenfetch
```shell

```
