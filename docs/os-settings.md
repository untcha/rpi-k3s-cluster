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
