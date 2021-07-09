## :one: Install Raspberry Pi OS :strawberry: on a  SD Card :floppy_disk: and prepare for first boot :rocket:

### :inbox_tray: Install Raspberry Pi OS with dd (macOS :material-apple: / Linux :fontawesome-brands-linux:)

:floppy_disk: Download [Raspberry Pi OS]

Use `diskutil list` to locate the mounted SD card and its disk identifier e.g. `disk2`:

``` bash
diskutil list
```

Example output:

``` bash
/dev/disk2 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *7.9 GB     disk2
   1:                 DOS_FAT_32 U                       7.9 GB     disk2s1
```

Format the SD card to `FAT32` and give it the name `RASPIOS`:

``` bash
sudo diskutil eraseDisk FAT32 RASPIOS MBRFormat /dev/disk2
```

Unmount `disk2`:

``` bash
diskutil unmountDisk /dev/disk2
```

Write the diskimage to the SD card with `dd`:

``` bash
sudo dd bs=1m if=[IMG] of=[DEVICE]
```

Replace `[IMG]` with the path to the image and `[DEVICE]` with the path to the SD card:

``` bash
sudo dd bs=1m if=2021-05-07-raspios-buster-armhf-lite.img of=/dev/disk2
```

You can check the write progress with ++ctrl+"T"++

### Enable `ssh` (Headless Setup)

`ssh` can be enabled by placing a file named `ssh`, without any extension, onto the boot partition of the SD card:

``` bash
touch /Volumes/boot/ssh
```

Unmount the SD card:

```bash
diskutil unmountDisk /dev/disk2
```

## :two: Initial Configuration with `raspi-config`

### Initial Configuration with `raspi-config`

Insert the SD card :floppy_disk: in the RasPi :strawberry: and boot the system. Connect to the RasPi via ssh :octicons-terminal-16:. The default username is `pi` and the default password is `raspberry`.

``` bash
ssh pi@<ip-address|domain>
```

To change the default password type

``` bash
sudo passwd pi
```

Finally, finish the configuration by typing

```bash
sudo raspi-config
```

### Expand the Filesystem

Select :six: `Advanced Options` :material-arrow-right: `A1 Expand the Filesystem` to use the complete space of the SD card

### Change Localisation Options

Select :five: `Localisation Options` :material-arrow-right: `L1 Locale`
Activate `de_DE.UTF-8 UTF-8` and `en_US.UTF-8 UTF-8` and select `Ok`.
In the next step select `en_US.UTF-8` as the default locale for the system environment.
This will be the default language for the entire system.

Select :five: `Localisation Options` :material-arrow-right: `L2 Timezone`
Select `Europe` as geographic area and `Berlin` as timezone.

Finish the configuration and reboot the system.

``` bash
sudo reboot
```

### Update the system

Type the following command to update the system and reboot:

``` bash
sudo apt update && sudo apt upgrade
```

``` bash
sudo reboot
```

## :three: Change IP Address and Hostname

### :globe_with_meridians: Static IP address

To change the network configuration from `dhcp` to `static` type

``` bash
sudo nano /etc/dhcpcd.conf
```

add the following:

``` bash
interface eth0
static ip_address=192.168.178.xxx/24
static routers=192.168.178.xxx
static domain_name_servers=192.168.178.xxx
```

### :abcd: Change hostname

At the Terminal, type the following command to open the hosts file:

``` bash
sudo nano /etc/hosts
```

and replace default `raspberry`

``` bash
127.0.1.1		raspberrypi
```
with your desired hostname.

Back at the Terminal, type the following command to open the hostname file:

``` bash
sudo nano /etc/hostname
```

Replace the default `raspberrypi` with the same hostname you put in the previous step.

Follow that command with

``` bash
sudo reboot
```

## :information_source: Informations about your Raspberry Pi

### Check your Raspberry Pi Revision, Serial and Model

The variants currently available are: https://www.raspberrypi-spy.co.uk/2012/09/checking-your-raspberry-pi-board-version/

``` bash
cat /proc/cpuinfo
```

``` bash
# Output:

processor	: 0
model name	: ARMv7 Processor rev 3 (v7l)
BogoMIPS	: 126.00
Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xd08
CPU revision	: 3

processor	: 1
model name	: ARMv7 Processor rev 3 (v7l)
BogoMIPS	: 126.00
Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xd08
CPU revision	: 3

processor	: 2
model name	: ARMv7 Processor rev 3 (v7l)
BogoMIPS	: 126.00
Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xd08
CPU revision	: 3

processor	: 3
model name	: ARMv7 Processor rev 3 (v7l)
BogoMIPS	: 126.00
Features	: half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x0
CPU part	: 0xd08
CPU revision	: 3

Hardware	: BCM2711
Revision	: c03114
Serial		: 10000000934fe714
Model		: Raspberry Pi 4 Model B Rev 1.4
```

``` bash
uname -a
```

``` bash
# Output:

Linux rpi-k3s-worker-04 5.10.17-v7l+ #1421 SMP Thu May 27 14:00:13 BST 2021 armv7l GNU/Linux
```

``` bash
cat /etc/os-release
```

```bash
# Output:

PRETTY_NAME="Raspbian GNU/Linux 10 (buster)"
NAME="Raspbian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
```

``` bash
cat /proc/device-tree/model
```

``` bash
# Output:

Raspberry Pi 4 Model B Rev 1.4
```

The Raspberry Pi [GPIO pinout guide]

[Raspberry Pi OS]: https://www.raspberrypi.org/software/
[GPIO pinout guide]: https://pinout.xyz/
