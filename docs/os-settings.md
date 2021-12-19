Intro blabla :-)

## Configure `sshd_config`

Set `PasswordAuthentication` to `no`:

``` bash
ansible all -b -m shell -a "sed -i -e 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config"
```

## Remove `snap`

Following the proposal of "Vladimir Strycek" @ [rpi4cluster.com](https://rpi4cluster.com/k3s/k3s-os-setting/#remove-snap) and remove `snap` to save some resources:

``` bash
ansible all -b -m shell -a "snap list"
```

``` bash
ansible all -b -m shell -a "snap remove lxd && snap remove core20 && snap remove snapd"
```

``` bash
ansible all -b -m shell -a "apt -y purge snapd && apt -y autoremove"
```

## Set the correct timezone

``` bash
ansible all -b -m shell -a "timedatectl set-timezone Europe/Berlin"
```

!!! info
    Same effect like:

    ``` bash
    sudo dpkg-reconfigure tzdata
    ```

## Update the OS

Update the OS packages to the latest ones:

``` bash
ansible all -m apt -a "upgrade=yes update_cache=yes" --become
```

!!! info
    Same effect like:

    ``` bash
    sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove
    ```

!!! tip
    Sometimes I realized that ansible had problems with the `apt` command when using `ansible all`. Therefor I'm using it for the master nodes and the worker nodes separate to be safe

    ``` bash
    ansible masters -m apt -a "upgrade=yes update_cache=yes" --become
    ```

    ``` bash
    ansible workers -m apt -a "upgrade=yes update_cache=yes" --become
    ```

Finally, clean up and reboot:

``` bash
ansible all -b -m shell -a "apt -y autoremove"
```

``` bash
ansible all -b -m reboot
```

``` bash
ansible masters -b -m reboot
```

``` bash
ansible workers -b -m reboot
```

## Install `linux-modules-extra-raspi`

Because of [k3s-issue-4234](https://github.com/k3s-io/k3s/issues/4234)

``` bash
ansible all -b -m shell -a "apt -y install linux-modules-extra-raspi"
```

``` bash
ansible all -b -m reboot
```

## Enabling cgroups and edit `/boot/firmware/cmdline.txt`

Standard installations do not start with `cgroups` enabled. K3S needs `cgroups` to start the systemd service. [K3S Documentation](https://rancher.com/docs/k3s/latest/en/advanced/#enabling-cgroups-for-raspbian-buster)

``` bash
ansible all -b -m shell -a "sed -i '$ s/$/ cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1 swapaccount=1/' /boot/firmware/cmdline.txt"
```

## Edit `/boot/firmware/config.txt`

Since all nodes are running headless, reducing the GPU memory gives some more MB of usable RAM:

``` bash
ansible all -b -m shell -a "echo '\ngpu_mem=16' | sudo tee -a /boot/firmware/config.txt"
```

## Set the hostname of all nodes

``` bash
ansible all -b -m shell -a "hostnamectl status | grep hostname"
```

``` bash
ansible all -b -m shell -a "hostnamectl set-hostname {{ var_hostname }}"
```

## Enabling legacy `iptables`

K3S networking features require `iptables` and do not work with `nftables`. [K3S Documentation](https://rancher.com/docs/k3s/latest/en/advanced/#enabling-legacy-iptables-on-raspbian-buster)

```bash
ansible all -b -m shell -a "iptables --version"
```

``` bash
ansible all -b -m shell -a "iptables -F"
```

``` bash
ansible all -b -m shell -a "update-alternatives --set iptables /usr/sbin/iptables-legacy"
```

``` bash
ansible all -b -m shell -a "update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy"
```

## Let the nodes know each other

Edit the `/etc/hosts` file on each node:

``` bash
ansible all -b -m shell -a "echo '\n192.168.178.210 rpi-k3s-master-01\n192.168.178.211 rpi-k3s-master-02\n192.168.178.212 rpi-k3s-master-03\n192.168.178.213 rpi-k3s-worker-01\n192.168.178.214 rpi-k3s-worker-02\n192.168.178.215 rpi-k3s-worker-03\n192.168.178.216 rpi-k3s-worker-04\n192.168.178.217 rpi-k3s-worker-05' | sudo tee -a /etc/hosts"
```

Check the result:

``` bash
ansible all -b -m shell -a "cat /etc/hosts"
```

``` bash
192.168.178.210 rpi-k3s-master-01
192.168.178.211 rpi-k3s-master-02
192.168.178.212 rpi-k3s-master-03
192.168.178.213 rpi-k3s-worker-01
192.168.178.214 rpi-k3s-worker-02
192.168.178.215 rpi-k3s-worker-03
192.168.178.216 rpi-k3s-worker-04
192.168.178.217 rpi-k3s-worker-05
```

Finally reboot all nodes:

``` bash
ansible all -b -m reboot
```
