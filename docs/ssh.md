## :one: SSH Basics

### Generate a new ssh keypair :material-key-chain-variant: (`id_rsa` and `id_rsa.pub`):

``` bash
cd ~/.ssh
```

``` bash
ssh-keygen -t rsa -b 4096 -C "<e-mail address>"
```

Usage:

``` bash
[-q] [-b bits] [-t dsa | ecdsa | ed25519 | rsa] [-N new_passphrase] [-C comment] [-f output_keyfile]
```

### :key: Show and copy the content of the public key `id_rsa.pub`

``` bash
cat id_rsa.pub
```

``` bash
pbcopy < id_rsa.pub
```

``` bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

### Use the keychain :material-key-chain-variant: in macOS :material-apple:

``` bash
touch ~/.ssh/config
```

``` bash
Host *
    UseKeychain yes
    IdentityFile  ~/.ssh/id_rsa
```

### Start the ssh-agent in the background and add your (private) ssh key

``` bash
eval "$(ssh-agent -s)"
```

``` bash
ssh-add ~/.ssh/id_rsa
```

### :mag: Show ssh fingerprint (SHA256)

``` bash
ssh-keygen -lf id_rsa.pub
```

###  :mag: Show ssh fingerprint (MD5)

``` bash
ssh-keygen -E md5 -lf id_rsa.pub
```

## :lock: Logging in with a ssh private key

### Deloy public key

``` bash
ssh pi@<ip-address|domain>
```

``` bash
mkdir ~/.ssh
```

``` bash
nano ~/.ssh/authorized_keys
```

Copy the content of the public key (`id_rsa.pub`) exactly as it is - no whitespaces or the like is accepted - and insert it into the `authorized_keys` file:

``` bash
pbcopy < ~/.ssh/id_rsa.pub
```

### :gear: Enable ssh key authentication

``` bash
sudo nano /etc/ssh/sshd_config
```

Change the following values:

``` bash
RSAAuthentification yes
PubkeyAuthentification yes
```

### :gear: (Optional) Disable password authentication

``` bash
sudo nano /etc/ssh/sshd_config
```

Change the following value:

``` bash
PasswordAuthentification no
```

### :gear: Restart ssh daemon

``` bash
sudo /etc/init.d/ssh restart
```

### :lock: (Optional) Login with ssh key

``` bash
ssh -i .ssh/id_rsa pi<ip-address|domain>
```

### :wrench: (Optional if necessary) Change permissions of the private ssh key

``` bash
chmod 600 id_rsa
```

## :ghost: Enable ssh daemon on macOS :material-apple:

### How to check if ssh remote login is enabled in macOS

``` bash
sudo systemsetup -getremotelogin
```

### :gear: Enable ssh remote login

``` bash
sudo systemsetup -setremotelogin on
```

### :gear: Disable ssh remote login

``` bash
sudo systemsetup -setremotelogin off
```
