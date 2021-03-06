# ArchLinux Kernel for Microsoft WSL

## Require

`# pacman -S asp pacman-contrib`

## Build Kernel
```shell
$ updpkgsums
$ makepkg -s -f
```

## Config
```
1. support network block device (nbd) `CONFIG_BLK_DEV_NBD`
2. support systemd Hash API `CONFIG_CRYPTO_USER_API_HASH`
3. support systemd-oomd `CONFIG_PSI`
4. support qemu-nbd with io_uring `CONFIG_IO_URING`
```

## Mount microsoft VHDX
```shell
$ sudo qemu-nbd -c /dev/nbd0 /mnt/d/test/ext4-extra.vhdx
$ sudo mount -t ext4 -o rw /dev/nbd0 /mnt/media
```

## Compress VHDX
Optimize-VHD works by trimming empty blocks, but "empty" doesn’t always mean what you might think because ext4fs is not NTFS.
So the first thing we need to do is to clean up the file system on the linux file system environment.

#### On WSL2
```shell
# create block device with vhdk, do not mount
sudo qemu-nbd --aio=io_uring -c /dev/nbd0 /mnt/d/test/ext4-extra.vhdx
# cleanup block
sudo zerofree /dev/nbd0
```
#### On Windows
```ps
# compress VHDK
PS C:\> Optimize-VHD -Path c:\test\dynamic.vhdx -Mode Full
```

## Use Systemd
```
see genie-systemd for more details
https://github.com/arkane-systems/genie
https://github.com/sorah/subsystemctl
```

## Mount Boot from NTFS (drvfs with fstab)
```fstab
# <file system> <dir> <type> <options> <dump> <pass>
D:\Develop\ArchLinux\kernel /boot drvfs rw,noatime
```

## Use custom Kernel (WSL2)
```conf
# .wslconfig
[wsl2]
kernel=D:\\Develop\\ArchLinux\\kernel\\vmlinuz-linux-wsl2
```

## screenfetch
```shell
# hsingyun @ HsingYun-PC-wsl in ~
$ uname -a
Linux HsingYun-PC-wsl 5.8.0-arch1-2-wsl-microsoft #3 SMP Sun, 09 Aug 2020 09:13:15 +0000 x86_64 GNU/Linux

# hsingyun @ HsingYun-PC-wsl in ~
$ screenfetch
                   -`
                  .o+`                 hsingyun@HsingYun-PC-wsl
                 `ooo/                 OS: Arch Linux (on the Windows Subsystem for Linux)
                `+oooo:                Kernel: x86_64 Linux 5.8.0-arch1-2-wsl-microsoft
               `+oooooo:               Uptime: 0m
               -+oooooo+:              Packages: 307
             `/:-:++oooo+:             Shell: zsh 5.8
            `/++++/+++++++:            Disk: 1.8T / 5.9T (30%)
           `/++++++++++++++:           CPU: AMD Ryzen 9 3900X 12-Core @ 24x 3.793GHz
          `/+++ooooooooooooo/`         RAM: 649MiB / 51345MiB
         ./ooosssso++osssssso+`
        .oossssso-````/ossssss+`
       -osssssso.      :ssssssso.
      :osssssss/        osssso+++.
     /ossssssss/        +ssssooo/-
   `/ossssso+/:-        -:/+osssso+-
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/

# hsingyun @ HsingYun-PC-wsl in ~
$ systemctl status
● HsingYun-PC-wsl
    State: running
     Jobs: 0 queued
   Failed: 0 units
    Since: Sun 2020-08-09 17:19:31 CST; 27s ago
   CGroup: /
           ├─user.slice
           │ └─user-1000.slice
           │   ├─user@1000.service
           │   │ └─init.scope
           │   │   ├─80 /usr/lib/systemd/systemd --user
           │   │   └─81 (sd-pam)
           │   └─session-c1.scope
           │     ├─ 78 /sbin/runuser -l hsingyun -w INSIDE_GENIE,WSL_DISTRO_NAME,WSL_INTEROP,WSLENV
           │     ├─ 87 -zsh
           │     ├─312 systemctl status
           │     └─313 less
           ├─init.scope
           │ └─1 /lib/systemd/systemd
           └─system.slice
             ├─systemd-udevd.service
             │ └─33 /usr/lib/systemd/systemd-udevd
             ├─systemd-journald.service
             │ └─23 /usr/lib/systemd/systemd-journald
             ├─sshd.service
             │ └─71 sshd: /usr/bin/sshd -D [listener] 0 of 10-100 startups
             ├─dbus.service
             │ └─67 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog>             └─systemd-logind.service
               └─72 /usr/lib/systemd/systemd-logind
```
