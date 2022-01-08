Intro blabla :-)

## Identifying disks for storage

``` bash
ansible all -b -m shell -a "lsblk -f"
```

``` bash
ansible all -b -m shell -a "wipefs -a /dev/{{ var_disk }}"
```

``` bash
ansible all -b -m shell -a "mkfs.ext4 /dev/{{ var_disk }}"
```

``` bash
ansible all -b -m shell -a "mkdir /storage"
```

``` bash
ansible all -b -m shell -a "mount /dev/{{ var_disk }} /storage"
```

``` bash
ansible all -b -m shell -a "blkid -s UUID -o value /dev/{{ var_disk }}"
```

``` bash
ansible all -b -m shell -a "echo 'UUID={{ var_uuid }}  /storage       ext4    defaults        0       2' | tee -a /etc/fstab"
```

``` bash
ansible all -b -m shell -a "grep UUID /etc/fstab"
```

``` bash
# Make sure mount have no issues
ansible all -b -m shell -a "mount -a"
```

``` bash
ansible all -b -m apt -a "name=open-iscsi state=present"
```

``` bash
ansible all -b -m shell -a "systemctl start open-iscsi"
```

``` bash
ansible all -b -m shell -a "apt install -y nfs-common"
ansible all -b -m shell -a "apt autoremove -y"
```

``` bash
ansible all -b -m reboot
ansible masters -b -m reboot
ansible workers -b -m reboot
```
