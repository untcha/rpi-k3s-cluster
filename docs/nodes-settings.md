In this chapter I'm going to prepare some basic setting like the `hosts` files and installing ansible incl. verifing ansible with a simple `ping` command.

## Prepare `hosts` file

First, prepare the `hosts` file on your machine. In my case my MacBook:

``` bash
sudo nano /etc/hosts
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

## Install Ansible

I'm going to use ansible to make life easier configuring Ubuntu on all the nodes. I'm not (yet) an ansible experts so no playbooks just firing plain ansible commands against all nodes!

``` bash
brew install ansible
```

Add this to your `.zshrc` (or `.bashrc`):

``` bash
export ANSIBLE_CONFIG=$HOME/.ansible/ansible.cfg
```

I used this ansible example config: [Example Config](https://github.com/ansible/ansible/blob/stable-2.11/examples/ansible.cfg)

Edit the `[defaults]` section and configure the `inventory`:

``` bash
inventory = ~/.ansible/hosts
```

## Prepare ansible `hosts` file

``` bash
nano ~/.ansible/hosts
```

This is my ansible hosts config:

``` yaml
[masters]
rpi-k3s-master-01 var_hostname=rpi-k3s-master-01 var_disk=sdb var_uuid=7db5fe78-1d19-41a8-a969-853a1ea81594
rpi-k3s-master-02 var_hostname=rpi-k3s-master-02 var_disk=sdb var_uuid=8de0bb09-b81c-439d-98a1-5c9ddd8ed901
rpi-k3s-master-03 var_hostname=rpi-k3s-master-03 var_disk=sda var_uuid=68ac6bf5-1063-41d7-a5c3-d6811304318f

[workers]
rpi-k3s-worker-01 var_hostname=rpi-k3s-worker-01 var_disk=sda var_uuid=3cc5af8f-8b8e-4867-a9cb-60649585d7b0
rpi-k3s-worker-02 var_hostname=rpi-k3s-worker-02 var_disk=sdb var_uuid=60657532-c469-4acc-ba53-df7328d1818d
rpi-k3s-worker-03 var_hostname=rpi-k3s-worker-03 var_disk=sdb var_uuid=47820b98-28e2-485b-ad63-ee5b5796ffe1
rpi-k3s-worker-04 var_hostname=rpi-k3s-worker-04 var_disk=sdb var_uuid=824c3003-cd42-45a4-868e-9bfcfc1f1bbd
rpi-k3s-worker-05 var_hostname=rpi-k3s-worker-05 var_disk=sdb var_uuid=58212edb-b909-4d2f-876d-4e40c596777a

[cluster:children]
masters
workers

[all:vars]
ansible_connection=ssh
ansible_user=ubuntu
```

!!! info
    The variables `var_disk` and `var_uuid` will be explained in the OS Settings chapter when it comes to preparing the USB Disks for `longhorn`

## Prepare login with ssh key

Log into each node and run

``` bash
nano ~/.ssh/authorized_keys
```

On your own machine (my MacBook) run

``` bash
pbcopy < ~/.ssh/id_rsa.pub
```

to copy your public ssh key and paste it in the `authorized_keys` file on each node.

!!! note
    TODO: try to copy the keys with this command

    ``` bash
    ssh-copy-id -i ~/.ssh/id_rsa.pub ubuntu@<node name>
    ```

## Very that ansible is working

``` bash
ansible all -b -m ping
```

``` bash
rpi-k3s-master-01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-master-02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-master-03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-worker-01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-worker-02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-worker-03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-worker-04 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
rpi-k3s-worker-05 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
