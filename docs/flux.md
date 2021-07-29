## Bootstrap GitHub Repository

```bash
flux check --pre
```

```bash
# Testing latest stable: v0.15.2
# --network-policy=false \
```

```bash
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPOSITORY \
  --branch=main \
  --path=./cluster/base \
  --version="v0.16.1" \
  --network-policy=false \
  --personal
```

## Clone the git repository

```bash
git clone https://github.com/$GITHUB_USER/$GITHUB_REPOSITORY
```

## pre-commit
https://pre-commit.com/
https://github.com/k8s-at-home/sops-pre-commit

### Install pre-commit

```bash
brew install pre-commit
```

### Create `.pre-commit-config.yaml` in the repository root

```bash
echo "repos:
- repo: https://github.com/k8s-at-home/sops-pre-commit
  rev: v2.0.3
  hooks:
  - id: forbid-secrets" >> .pre-commit-config.yaml
```

Then run:

```bash
pre-commit install-hooks
```

```bash
pre-commit run --all-files
```

## Kustomization

TODO: create kustomization.yaml files recursively

## Helm Repositories

```bash
# longhorn

flux create source helm longhorn \
    --url https://charts.longhorn.io \
    --export > longhorn-charts.yaml
```

```bash
# cert-manager

flux create source helm jetstack \
    --url https://charts.jetstack.io \
    --export > jetstack-charts.yaml
```

```bash
# traefik

flux create source helm traefik \
    --url https://helm.traefik.io/traefik \
    --export > traefik-charts.yaml
```

```bash
# influxdb, chronograf, telegraf

flux create source helm influxdata \
    --url https://helm.influxdata.com \
    --export > traefik-charts.yaml
```

```bash
# grafana

flux create source helm grafana \
    --url https://grafana.github.io/helm-charts \
    --export > grafana-charts.yaml
```

```bash
# prometheus

flux create source helm prometheus-community \
    --url https://prometheus-community.github.io/helm-charts \
    --export > prometheus-community-charts.yaml
```

```bash
# portainer

flux create source helm portainer \
    --url https://portainer.github.io/k8s/ \
    --export > portainer-charts.yaml
```

```bash
# k8s-at-home

flux create source helm k8s-at-home \
    --url https://k8s-at-home.com/charts/ \
    --export > k8s-at-home-charts.yaml
```

```bash
# groundhog2k

flux create source helm groundhog2k \
    --url https://groundhog2k.github.io/helm-charts/ \
    --export > groundhog2k-charts.yaml
```

```bash
# mojo2600

flux create source helm mojo2600 \
    --url https://mojo2600.github.io/pihole-kubernetes/ \
    --export > mojo2600-charts.yaml
```

## Helm Chart Values

```bash
helm show values <repository/chart> <chart>-values.yaml
```

## Helm Release

### Longhorn

```bash
flux create helmrelease longhorn \
  --source=HelmRepository/longhorn \
  --chart=longhorn \
  --chart-version="1.1.2" \
  --target-namespace=longhorn-system \
  --values=longhorn-values.yaml \
  --export > longhorn-helmrelease.yaml
```

### Cert-Manager

```bash
flux create helmrelease cert-manager \
  --source=HelmRepository/jetstack \
  --chart=cert-manager \
  --chart-version="v1.4.0" \
  --target-namespace=cert-manager \
  --values=cert-manager-values.yaml \
  --export > cert-manager-helmrelease.yaml
```

### Traefik

```bash
flux create helmrelease traefik \
  --source=HelmRepository/traefik \
  --chart=traefik \
  --chart-version="10.0.0" \
  --target-namespace=traefik \
  --values=traefik-values.yaml \
  --export > traefik-helmrelease.yaml
```

### InfluxDB, Chronograf, Telegraf

```bash
flux create helmrelease influxdb \
  --source=HelmRepository/influxdata \
  --chart=influxdb \
  --chart-version="4.9.14" \
  --target-namespace=influxdata \
  --values=influxdb-values.yaml \
  --export > influxdb-helmrelease.yaml
```

```bash
flux create helmrelease chronograf \
  --source=HelmRepository/influxdata \
  --chart=chronograf \
  --chart-version="1.1.24" \
  --target-namespace=influxdata \
  --values=chronograf-values.yaml \
  --export > chronograf-helmrelease.yaml
```

```bash
flux create helmrelease telegraf \
  --source=HelmRepository/influxdata \
  --chart=telegraf \
  --chart-version="1.8.2" \
  --target-namespace=influxdata \
  --values=telegraf-values.yaml \
  --export > telegraf-helmrelease.yaml
```

### Grafana

```bash
flux create helmrelease grafana \
  --source=HelmRepository/grafana \
  --chart=grafana \
  --chart-version="6.13.6" \
  --target-namespace=grafana \
  --values=grafana-values.yaml \
  --export > grafana-helmrelease.yaml
```

### Prometheus

```bash
flux create helmrelease prometheus \
  --source=HelmRepository/prometheus-community \
  --chart=prometheus \
  --chart-version="14.4.1" \
  --target-namespace=prometheus \
  --values=prometheus-values.yaml \
  --export > prometheus-helmrelease.yaml
```

### Portainer

```bash
flux create helmrelease portainer \
  --source=HelmRepository/portainer \
  --chart=portainer \
  --chart-version="1.0.15" \
  --target-namespace=portainer \
  --values=portainer-values.yaml \
  --export > portainer-helmrelease.yaml
```

### LibreSpeed

```bash
flux create helmrelease librespeed \
  --source=HelmRepository/k8s-at-home \
  --chart=librespeed \
  --chart-version="4.1.0" \
  --target-namespace=tools \
  --values=librespeed-values.yaml \
  --export > librespeed-helmrelease.yaml
```

### Nextcloud, postgres, redis 

```bash
flux create helmrelease nextcloud \
  --source=HelmRepository/groundhog2k \
  --chart=nextcloud \
  --chart-version="0.6.2" \
  --target-namespace=nextcloud \
  --values=nextcloud-values.yaml \
  --export > nextcloud-helmrelease.yaml
```

```bash
flux create helmrelease postgres \
  --source=HelmRepository/groundhog2k \
  --chart=postgres \
  --chart-version="0.2.11" \
  --target-namespace=nextcloud \
  --values=postgres-values.yaml \
  --export > postgres-helmrelease.yaml
```

```bash
flux create helmrelease mariadb \
  --source=HelmRepository/groundhog2k \
  --chart=mariadb \
  --chart-version="0.2.13" \
  --target-namespace=nextcloud \
  --values=mariadb-values.yaml \
  --export > mariadb-helmrelease.yaml
```

```bash
flux create helmrelease redis \
  --source=HelmRepository/groundhog2k \
  --chart=redis \
  --chart-version="0.4.7" \
  --target-namespace=nextcloud \
  --values=redis-values.yaml \
  --export > redis-helmrelease.yaml
```

## Useful commands

```bash
watch flux get all
```
