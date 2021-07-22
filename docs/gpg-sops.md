## Installation

Install `gnupg` and `sops`

```bash
brew install gnupg sops
```

## Import existing keys

```bash
gpg --import public.key
gpg --allow-secret-key-import --import private.key
```

## Change trust

```bash
gpg --edit-key [key-id]
```

run the `trust`command and change the trust. Or just reimport the trustlevel (if available):

```bash
gpg --import-ownertrust < trustlevel.txt
```

```bash
gpg --export-ownertrust > trustlevel.txt
```

## List keys

```bash
gpg --list-keys
```

## Export keys

```bash
# public key
gpg --output public-key.asc --armor --export [key-id]

# private key
gpg --output private-key.asc --armor --export-secret-key [key-id]

# create backup key
gpg --output backup.asc --armor --export-secret-keys --export-options export-backup [key-id]

# This will export all necessary information to restore the secrets keys including the trust database information.
# https://www.jabberwocky.com/software/paperkey/
```

## Encrypt and decrypt with `gpg`

#### Encrypt:

```bash
gpg -e -o file.txt.encrypted -r [key-id] file.txt
```

#### Decrypt:

```bash
gpg -d -o file.txt.decrypted file.txt.encrypted
```

## Encrypt secrets in config files with `SOPS`:

Find the public fingerprint for the key:

```bash
gpg --list-keys "[key-id]" | grep pub -A 1 | grep -v pub
```

Use sops to encrypt the sensitive fields in a yaml file (e.g. my kubeconfig):

```bash
# --in-place: encrypts in the same file no new file with the encrypted fields will be created
# --encrypted-regex: encrypt only the fields mentioned in the regex
# $KEY_FP is the public fingerprint for the key

sops --encrypt --in-place --encrypted-regex 'certificate-authority-data|client-certificate-data|client-key-data' --pgp $KEY_FP config.yaml
```

```bash
# same creating a new file

sops --encrypted-regex 'certificate-authority-data|client-certificate-data|client-key-data' --pgp $KEY_FP --encrypt config.yaml > config_encrypted.yaml
```

```bash
# encrypts ALL fields in the given yaml

sops --pgp $KEY_FP --encrypt config.yaml > config_encrypted.yaml
```

## Decrypt secrets in config files with `SOPS`:

For decryption `gpg-agent` needs to be unlocked with the private key password before. First run:

```bash
gpgconf --reload gpg-agent
```

And then append the following to your `.zshrc` (or `.bash_profile`):

```bash
GPG_TTY=$(tty)
export GPG_TTY
```

Now decrypt your config file:

```bash
sops --decrypt config_encrypted.yaml > config_decrypted.yaml
```
