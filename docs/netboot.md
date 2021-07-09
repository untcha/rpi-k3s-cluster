## :material-bullseye-arrow: Prerequisites

I assume that an `iSCSI` capabale server is in place. In my case this is a QNAP NAS with configured `iSCSI targets` and already created and attached `block-based LUNs`.

:material-target: `iSCSI-TARGET1` :material-transit-connection-horizontal: :octicons-database-16: `LUN_m01` :material-transit-connection-horizontal: :strawberry: `rpi-k3s-master-01`<br>
:material-target: `iSCSI-TARGET2` :material-transit-connection-horizontal: :octicons-database-16: `LUN_m02` :material-transit-connection-horizontal: :strawberry: `rpi-k3s-master-02`<br>
:material-target: `iSCSI-TARGET3` :material-transit-connection-horizontal: :octicons-database-16: `LUN_m03` :material-transit-connection-horizontal: :strawberry: `rpi-k3s-master-03`<br>
:material-target: `iSCSI-TARGET4` :material-transit-connection-horizontal: :octicons-database-16: `LUN_w01` :material-transit-connection-horizontal: :strawberry: `rpi-k3s-worker-01`<br>

and so on ...

!!! warning
    TODO: draw.io diagram

Since I don't know if my solution is cluster ready I did not attached more than one `LUN` to a `target` and gave every RasPi a `LUN` with an unique `iSCSI target`.

* `<TARGET_IP>`: the IP address of the iSCSI server.
* `<TARGET_NAME>`: the iSCSI Qualified Name (IQN) of the iSCSI target (e.g. `iqn.2004-04.com.qnap:ts-870pro:iscsi.rpik3smaster01.e024de`).
* `<INITIATOR_IP>`: the IP address of the iSCSI client.
* `<INITIATOR_NAME>`: is an IQN defined for the Raspberry Pi (e.g. `iqn.2005-03.org.open-iscsi:431c86e4ae5c`). This can be anything as long as it is in IQN format.
* `<DEV_FILE>`: is the device file for the connected iSCSI LUN (e.g. `/dev/sda`). Will be defined later.
* `<DEV_UUID>`: is the UUID for the connected iSCSI LUN (e.g. `2dfdd3e6-4036-4b80-829d-8ddaa3c64005`). This will be defined later.
* `<INITRD>`: is the name of the initial ramdisk used during boot (e.g. `initrd.img-5.10.17-v7l+`). This will be defined later.
* `<NETBOOT_MASTER_IP>`: is the IP address of the `tftp` server.

For convenience I exportet all values as environment variables:

``` bash
export TARGET_IP=192.168.178.xxx
export TARGET_NAME=...
export INITIATOR_NAME=...
export INITIATOR_IP=192.168.178.xxx
export DEV_FILE=/dev/sda
export DEV_UUID=...
export INITRD=...
export NETBOOT_MASTER_IP=192.168.178.xxx
```

## :one: :rocket: Prepare the :strawberry: RasPi for initial boot from :floppy_disk: SD Card
Getting a complete new RasPi prepared to boot from an `iSCSI target` you need to boot it at least one time from an `SD Card`. So I flashed a small `SD Card` with the current `Raspberry OS Lite` enabled `SSH` and did the following steps:

!!! note
    I'm using only RasPi's from the 4th generation so I can configure the boot order from the `raspi-config`

!!! warning
    TODO: link to Raspberry Pi Setup Tutorial

``` bash
sudo passwd pi
```

``` bash
sudo raspi-config
```

:gear: :six: Advanced Options :material-arrow-right: A1 Expand the Filesystem <br>
:gear: :five: Localisation Options :material-arrow-right: L1 Locale <br>
:gear: :five: Localisation Options :material-arrow-right: L2 Timezone <br>
:gear: :six: Advanced Options :material-arrow-right: A6 Boot Order :material-arrow-right: B3 Network Boot <br>

Ensure the system is updated with latest packages and kernel
``` bash 
sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove
```

``` bash
sudo reboot
```

``` bash
# ls /var/cache/apt/archives/
sudo apt-get clean
```

## :two: :rocket: Prepare the :strawberry: RasPi for netboot from an iSCSI target

Install the `open-iscsi` package and start the service:

``` bash
sudo apt install open-iscsi
```

``` bash
sudo systemctl start open-iscsi
```

Create a new unique initator name for the RasPi:

``` bash
iscsi-iname
```

Replace the default initator name with the new generated one. I think this is not necessarily but in case I make a backup of the SD Card new RasPi's would have always the same initiator name. This is what I want to prevent.

``` bash
sudo nano /etc/iscsi/initiatorname.iscsi
```

Discover and login to the desired iSCSI targets to connect the LUN:

``` bash
sudo iscsiadm --mode discovery --type sendtargets --portal $TARGET_IP
```

``` bash
sudo iscsiadm --mode node --targetname $TARGET_NAME --portal $TARGET_IP --login
```

The iSCSI LUN should now be connected, so we will use `fdisk` to determine its block device file. This defines `<DEV_FILE>`, in this case `/dev/sda`.

``` bash
sudo fdisk -l
```

Create the filesystem on the new device:

``` bash
sudo mkfs.ext4 $DEV_FILE
```

We also need the UUID for the new device, which we will get with `blkid`. This defines `<DEV_UUID>`:

```bash
sudo blkid $DEV_FILE
```

``` bash
$ /dev/sda: UUID="2dfdd3e6-4036-4b80-829d-8ddaa3c64005" TYPE="ext4"
```

Enable the iSCSI module as part of the initial ramdisk, which will be used during boot to mount the root partition, then update the initial ramdisk.

```bash
sudo touch /etc/iscsi/iscsi.initramfs
```

```bash
sudo update-initramfs -v -k `uname -r` -c
```

The new initrd can be found in `/boot`. This defines `<INITRD>`:

```bash
ls -lrt /boot/init*
```

``` bash
$ /boot/initrd.img-5.10.17-v7l+
```

## :three: Switch to the :material-server: `tftp` server

I my case I prepared another RasPi which has `tftp` and `dnsmasq` enabled to serve the necessary boot files.

!!! warning
    TODO: netboot master documentation

On the tftp server root, in `/tftpboot` in my case, create a directory with the IP address of the new RasPi:

``` bash
sudo mkdir -p /tftpboot/$INITIATOR_IP
```

``` bash
sudo chmod -R 777 /tftpboot/$INITIATOR_IP
```

Retrieve all boot files from the new RasPi to this new folder:

``` bash
scp -r pi@$INITIATOR_IP:/boot/* /tftpboot/$INITIATOR_IP/
```

Modify the `config.txt` (in the tftp server), and add the following line:

```bash
echo "initramfs $INITRD followkernel" | tee -a /tftpboot/$INITIATOR_IP/config.txt
```

## :four: Switch back to the new netboot client :strawberry: RasPi

Back on the new RasPi mount the new device:

```bash
sudo mount $DEV_FILE /mnt
```

Then selectively sync the current root filesystem to the new root filesystem and create empty directories for the things we didn't sync:

```bash
sudo rsync -avhP --exclude /boot --exclude /proc --exclude /sys --exclude /dev --exclude /mnt / /mnt/
```

```bash
sudo mkdir /mnt/{dev,proc,sys,boot,mnt}
```

Update the mount configuration for the new root partition in `/mnt/etc/fstab` by replacing the existing root (`/`) line with the following:

``` bash
echo "$NETBOOT_MASTER_IP:/tftpboot/$INITIATOR_IP /boot nfs defaults,vers=4.1,proto=tcp 0 0" | sudo tee -a /mnt/etc/fstab
```

!!! warning
    Also comment out every line except `proc`!

``` bash
sudo nano /mnt/etc/fstab
```

``` bash
proc            /proc           proc    defaults          0       0
# PARTUUID=54332817-01  /boot           vfat    defaults          0       2
# PARTUUID=54332817-02  /               ext4    defaults,noatime  0       1
# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that
192.168.178.xxx:/tftpboot/192.168.178.xxx /boot nfs defaults,vers=4.1,proto=tcp 0 0
```

Your network interface will also be configured at boot time during the initrd phase, so you may want to disable the dhcp client for this card or you will get 2 addresses for a single interface in `/mnt/etc/dhcpcd.conf`, add

``` bash
echo -e "\ndenyinterfaces eth0" | sudo tee -a /mnt/etc/dhcpcd.conf
```

If you do that, you will also need to manually set your DNS, in `/mnt/etc/resolvconf.conf`:

``` bash
sudo nano /mnt/etc/resolvconf.conf
```

## :five: Switch to the :material-server: `tftp` server (again)

Now, you need to set all required parameters to connect to your iSCSI drive during the boot.
For that, modify the `cmdline.txt` (on your `tftp` server), and add this (:warning: keep everything on a single line :warning:):

Run this command to clear the existing parameters in the `cmdline.txt`

``` bash
echo | tee /tftpboot/$INITIATOR_IP/cmdline.txt
```
!!! info
    I exported the important values to environment variables during this guide. To get all parameters correct I just echo the following string on the client RasPi and copy / paste it to the other terminal on the netboot master to edit the `cmdline.txt`

``` bash
echo "dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 ip=dhcp root=UUID=$DEV_UUID rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait qmap=fr ISCSI_INITIATOR=$INITIATOR_NAME ISCSI_TARGET_NAME=$TARGET_NAME ISCSI_TARGET_IP=$TARGET_IP ISCSI_TARGET_PORT=3260 rw" | tee /tftpboot/$INITIATOR_IP/cmdline.txt
```

Now, shutdown :material-power: the new :strawberry: RasPi, remove the :fontawesome-solid-sd-card: `SD Card` and boot it up again:

```bash
sudo shutdown -h now
```
