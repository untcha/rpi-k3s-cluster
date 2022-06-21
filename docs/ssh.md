## 1. SSH Basics

### 1.1 Generate a new ssh keypair (`id_rsa` and `id_rsa.pub`):

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

### 1.2 Change the passphrase of an ssh key

To change the passphrase of the default key:

``` bash
ssh-keygen -p
```

To change the passphrase of a specific key `id_rsa`

``` bash
ssh-keygen -p -f ~/.ssh/id_dsa
```

### 1.3 Show and copy the content of the public key `id_rsa.pub`

``` bash
cat id_rsa.pub
```

``` bash
pbcopy < id_rsa.pub
```

``` bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

### 1.4 Use the keychain in macOS

``` bash
touch ~/.ssh/config
```

``` bash
Host *
    UseKeychain yes
    IdentityFile  ~/.ssh/id_rsa
```

### 1.5 Start the ssh-agent in the background and add your (private) ssh key

``` bash
eval "$(ssh-agent -s)"
```

``` bash
ssh-add ~/.ssh/id_rsa
```

### 1.6 Show ssh fingerprint (SHA256)

``` bash
ssh-keygen -lf id_rsa.pub
```

###  1.7 Show ssh fingerprint (MD5)

``` bash
ssh-keygen -E md5 -lf id_rsa.pub
```

## 2. Logging in with a ssh private key

### 2.1 Deloy public key

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

### 2.2 Enable ssh key authentication

``` bash
sudo nano /etc/ssh/sshd_config
```

Change the following values:

``` bash
RSAAuthentification yes
PubkeyAuthentification yes
```

### 2.3 (Optional) Disable password authentication

``` bash
sudo nano /etc/ssh/sshd_config
```

Change the following value:

``` bash
PasswordAuthentification no
```

### 2.4 Restart ssh daemon

``` bash
sudo /etc/init.d/ssh restart
```

### 2.5 (Optional) Login with ssh key

``` bash
ssh -i .ssh/id_rsa pi<ip-address|domain>
```

### 2.6 (Optional if necessary) Change permissions of the private ssh key

``` bash
chmod 600 id_rsa
```

## 3. Enable ssh daemon on macOS

### 3.1 How to check if ssh remote login is enabled in macOS

``` bash
sudo systemsetup -getremotelogin
```

### 3.2 Enable ssh remote login

``` bash
sudo systemsetup -setremotelogin on
```

### 3.3 Disable ssh remote login

``` bash
sudo systemsetup -setremotelogin off
```
