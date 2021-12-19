## Prepare `hosts` file

First, prepare the `hosts` file on your machine. In my case my MacBook:

```bash
sudo nano /etc/hosts
```

```bash
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

```bash
brew install ansible
```

Add this to your `.zshrc` (or `.bashrc`):

```bash
export ANSIBLE_CONFIG=$HOME/.ansible/ansible.cfg
```

I used this ansible example config: [Example Config](https://github.com/ansible/ansible/blob/stable-2.11/examples/ansible.cfg)

Edit the `[defaults]` section and configure the `inventory`:

```bash
inventory = ~/.ansible/hosts
```
