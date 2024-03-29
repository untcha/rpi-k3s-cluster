## Prerequisites

### Create a Flux GPG Key and export the fingerprint

``` bash
gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Real: ${FLUX_KEY_NAME}
Name-Comment: ${FLUX_KEY_COMMENT}
EOF
```

``` bash
gpg --list-secret-keys "${FLUX_KEY_NAME}"
```

``` bash
gpg --list-keys "$FLUX_KEY_NAME" | grep pub -A 1 | grep -v pub
```

### Add the Flux GPG key in-order for Flux to decrypt SOPS secrets

TODO: place encrypted sops-gpg.yaml in the repository

``` bash
kubectl create namespace flux-system
```

``` bash
gpg --export-secret-keys --armor "${FLUX_KEY_FP}" |
kubectl create secret generic sops-gpg \
    --namespace=flux-system \
    --from-file=sops.asc=/dev/stdin
```

### Create / adapt `.sops.yaml` in the repository root

``` bash
echo "---
creation_rules:
- encrypted_regex: '^(data|stringData)$'
  pgp: >-
    ${K3S_CLUSTER_GPG_KEY_ID}" >> .sops.yaml
```

### Modify the `gotk-sync.yaml`

Append the following:

```yaml
  ...
  validation: client
  # add the sops provider and secret reference
  decryption:
    provider: sops
    secretRef:
      name: sops-gpg
```

## Bootstrap GitHub Repository

``` bash
flux check --pre
```

``` bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPOSITORY \
  --branch=main \
  --path=./cluster/base \
  --version=$FLUX_VERSION \
  --network-policy=false

# --network-policy=false \
# --personal
```

## Clone the git repository

``` bash
git clone https://github.com/$GITHUB_USER/$GITHUB_REPOSITORY
```

## pre-commit
https://pre-commit.com/
https://github.com/k8s-at-home/sops-pre-commit

### Install pre-commit

``` bash
brew install pre-commit
```

### Create `.pre-commit-config.yaml` in the repository root

``` bash
echo "repos:
- repo: https://github.com/k8s-at-home/sops-pre-commit
  rev: v2.0.3
  hooks:
  - id: forbid-secrets" >> .pre-commit-config.yaml
```

Then run:

``` bash
pre-commit install-hooks
```

``` bash
pre-commit run --all-files
```

## Kustomization

TODO: create kustomization.yaml files recursively

## Helm Repositories

``` bash
# grafana

flux create source helm grafana \
    --url https://grafana.github.io/helm-charts \
    --export > grafana-charts.yaml
```

``` bash
# nextcloud, postgres, redis

flux create source helm groundhog2k \
    --url https://groundhog2k.github.io/helm-charts/ \
    --export > groundhog2k-charts.yaml
```

``` bash
# influxdb, chronograf, telegraf

flux create source helm influxdata \
    --url https://helm.influxdata.com \
    --export > traefik-charts.yaml
```

``` bash
# cert-manager

flux create source helm jetstack \
    --url https://charts.jetstack.io \
    --export > jetstack-charts.yaml
```

``` bash
# librespeed

flux create source helm k8s-at-home \
    --url https://k8s-at-home.com/charts/ \
    --export > k8s-at-home-charts.yaml
```

``` bash
# longhorn

flux create source helm longhorn \
    --url https://charts.longhorn.io \
    --export > longhorn-charts.yaml
```

``` bash
# metallb

flux create source helm metallb \
    --url https://metallb.github.io/metallb \
    --export > metallb-charts.yaml
```

``` bash
# portainer

flux create source helm portainer \
    --url https://portainer.github.io/k8s/ \
    --export > portainer-charts.yaml
```

``` bash
# prometheus

flux create source helm prometheus-community \
    --url https://prometheus-community.github.io/helm-charts \
    --export > prometheus-community-charts.yaml
```

``` bash
# traefik

flux create source helm traefik \
    --url https://helm.traefik.io/traefik \
    --export > traefik-charts.yaml
```

``` bash
# openldap

flux create source helm openldap \
    --url https://jp-gouin.github.io/helm-openldap/ \
    --export > openldap-charts.yaml
```

## Helm Chart Values

``` bash
helm show values <repository/chart> <chart>-values.yaml
```

## Helm Release

### Authelia

``` bash
flux create helmrelease authelia \
  --source=HelmRepository/authelia \
  --chart=authelia \
  --chart-version="0.8.38" \
  --target-namespace=authentication \
  --values=authelia-values.yaml \
  --export > authelia-helmrelease.yaml
```

### Authelia - Postgres

``` bash
flux create helmrelease authelia-postgres \
  --source=HelmRepository/groundhog2k \
  --chart=postgres \
  --chart-version="0.3.10" \
  --target-namespace=authentication \
  --values=postgres-values.yaml \
  --export > postgres-helmrelease.yaml
```

### Wordpress (Simone)

``` bash
flux create helmrelease wp-simone-wordpress \
  --source=HelmRepository/groundhog2k \
  --chart=wordpress \
  --chart-version="0.6.1" \
  --target-namespace=wp-simone \
  --values=wordpress-values.yaml \
  --export > wordpress-helmrelease.yaml
```

### Wordpress (Simone) - MariaDB

``` bash
flux create helmrelease wp-simone-mariadb \
  --source=HelmRepository/groundhog2k \
  --chart=mariadb \
  --chart-version="0.5.0" \
  --target-namespace=wp-simone \
  --values=mariadb-values.yaml \
  --export > mariadb-helmrelease.yaml
```

### docker-registry

``` bash
flux create helmrelease docker-registry \
  --source=HelmRepository/twuni \
  --chart=docker-registry \
  --chart-version="2.1.0" \
  --target-namespace=docker-registry \
  --values=docker-registry-values.yaml \
  --export > docker-registry-helmrelease.yaml
```

### Gitea

``` bash
flux create helmrelease gitea \
  --source=HelmRepository/groundhog2k \
  --chart=gitea \
  --chart-version="0.5.13" \
  --target-namespace=gitea \
  --values=gitea-values.yaml \
  --export > gitea-helmrelease.yaml
```

### Gitea - Postgres

``` bash
flux create helmrelease gitea-postgres \
  --source=HelmRepository/groundhog2k \
  --chart=postgres \
  --chart-version="0.3.10" \
  --target-namespace=gitea \
  --values=postgres-values.yaml \
  --export > postgres-helmrelease.yaml
```

### Gitea - Redis

``` bash
flux create helmrelease gitea-redis \
  --source=HelmRepository/groundhog2k \
  --chart=redis \
  --chart-version="0.5.2" \
  --target-namespace=gitea \
  --values=redis-values.yaml \
  --export > redis-helmrelease.yaml
```

### Kured

``` bash
flux create helmrelease kured \
  --source=HelmRepository/kured \
  --chart=kured \
  --chart-version="2.11.2" \
  --target-namespace=kube-system \
  --values=kured-values.yaml \
  --export > kured-helmrelease.yaml
```

### Reloader

``` bash
flux create helmrelease reloader \
  --source=HelmRepository/stakater \
  --chart=reloader \
  --chart-version="v0.0.117" \
  --target-namespace=kube-system \
  --values=reloader-values.yaml \
  --export > reloader-helmrelease.yaml
```

### Grafana

``` bash
flux create helmrelease grafana \
  --source=HelmRepository/grafana \
  --chart=grafana \
  --chart-version="6.32.2" \
  --target-namespace=monitoring \
  --values=grafana-values.yaml \
  --export > grafana-helmrelease.yaml
```

### Influxdata - InfluxDB

``` bash
flux create helmrelease influxdb \
  --source=HelmRepository/influxdata \
  --chart=influxdb \
  --chart-version="4.10.6" \
  --target-namespace=monitoring \
  --values=influxdb-values.yaml \
  --export > influxdb-helmrelease.yaml
```

### Influxdata - Chronograf

``` bash
flux create helmrelease chronograf \
  --source=HelmRepository/influxdata \
  --chart=chronograf \
  --chart-version="1.2.3" \
  --target-namespace=monitoring \
  --values=chronograf-values.yaml \
  --export > chronograf-helmrelease.yaml
```

### Kube-Prometheus-Stack

``` bash
flux create helmrelease kube-prometheus-stack \
  --source=HelmRepository/prometheus-community \
  --chart=kube-prometheus-stack \
  --chart-version="40.0.2" \
  --target-namespace=monitoring \
  --values=kube-prometheus-stack-values.yaml \
  --export > kube-prometheus-stack-helmrelease.yaml
```

### Nextcloud

``` bash
interval: 1m0s
timeout: 25m (!!!)

flux create helmrelease nextcloud \
  --source=HelmRepository/groundhog2k \
  --chart=nextcloud \
  --chart-version="0.10.1" \
  --target-namespace=nextcloud \
  --values=nextcloud-values.yaml \
  --export > nextcloud-helmrelease.yaml
```

### Nextcloud - Postgres

``` bash
flux create helmrelease nextcloud-postgres \
  --source=HelmRepository/groundhog2k \
  --chart=postgres \
  --chart-version="0.3.3" \
  --target-namespace=nextcloud \
  --values=postgres-values.yaml \
  --export > postgres-helmrelease.yaml
```

### Nextcloud - Redis

``` bash
flux create helmrelease nextcloud-redis \
  --source=HelmRepository/groundhog2k \
  --chart=redis \
  --chart-version="0.4.11" \
  --target-namespace=nextcloud \
  --values=redis-values.yaml \
  --export > redis-helmrelease.yaml
```

### Vaultwarden - Postgres

``` bash
flux create helmrelease vaultwarden-postgres \
  --source=HelmRepository/groundhog2k \
  --chart=postgres \
  --chart-version="0.3.10" \
  --target-namespace=vaultwarden \
  --values=postgres-values.yaml \
  --export > postgres-helmrelease.yaml
```

### Cert-Manager

``` bash
flux create helmrelease cert-manager \
  --source=HelmRepository/jetstack \
  --chart=cert-manager \
  --chart-version="v1.8.2" \
  --target-namespace=cert-manager \
  --values=cert-manager-values.yaml \
  --export > cert-manager-helmrelease.yaml
```

### Traefik

``` bash
flux create helmrelease traefik \
  --source=HelmRepository/traefik \
  --chart=traefik \
  --chart-version="10.24.0" \
  --target-namespace=traefik \
  --values=traefik-values.yaml \
  --export > traefik-helmrelease.yaml
```

### MetalLB

``` bash
flux create helmrelease metallb \
  --source=HelmRepository/metallb \
  --chart=metallb \
  --chart-version="0.12.1" \
  --target-namespace=metallb-system \
  --values=metallb-values.yaml \
  --export > metallb-helmrelease.yaml
```

### Longhorn

``` bash
flux create helmrelease longhorn \
  --source=HelmRepository/longhorn \
  --chart=longhorn \
  --chart-version="1.2.4" \
  --target-namespace=longhorn-system \
  --values=longhorn-values.yaml \
  --export > longhorn-helmrelease.yaml
```

### nfs-provisioner

``` bash
  ### NICHT mehr nötig! --> Kustomization angepasst!
  namespace: flux-system
  annotations:
    kustomize.toolkit.fluxcd.io/substitute: disabled (!!!)

flux create helmrelease nfs-provisioner \
  --source=HelmRepository/nfs-provisioner \
  --chart=nfs-subdir-external-provisioner \
  --chart-version="4.0.16" \
  --target-namespace=storage \
  --values=nfs-provisioner-values.yaml \
  --export > nfs-provisioner-helmrelease.yaml
```

### nfs-test-provisioner

``` bash
flux create helmrelease nfs-test-provisioner \
  --source=HelmRepository/nfs-provisioner \
  --chart=nfs-subdir-external-provisioner \
  --chart-version="4.0.16" \
  --target-namespace=storage \
  --values=nfs-test-provisioner-values.yaml \
  --export > nfs-test-provisioner-helmrelease.yaml
```

## Useful commands

``` bash
echo -n 'test' | base64
```

``` bash
watch flux get all
```

## Links and References
[https://blog.stack-labs.com/code/kustomize-101/](https://blog.stack-labs.com/code/kustomize-101/)

[https://blog.sldk.de/2021/02/introduction-to-gitops-on-kubernetes-with-flux-v2/](https://blog.sldk.de/2021/02/introduction-to-gitops-on-kubernetes-with-flux-v2/)
[https://blog.sldk.de/2021/03/handling-secrets-in-flux-v2-repositories-with-sops/](https://blog.sldk.de/2021/03/handling-secrets-in-flux-v2-repositories-with-sops/)


