#!/bin/bash

echo "Create flux-system namespace"
kubectl create namespace flux-system

echo "Create flux secret"
gpg --export-secret-keys --armor "${K3S_CLUSTER_GPG_KEY_NAME}" |
kubectl create secret generic sops-gpg \
    --namespace=flux-system \
    --from-file=sops.asc=/dev/stdin

echo "Bootstrap GitHub and deploy workload"
flux bootstrap github \
  --owner="$GITHUB_USER" \
  --repository="$GITHUB_REPOSITORY" \
  --private=true \
  --personal=true \
  --branch=main \
  --path=./cluster/base \
  --version="$FLUX_VERSION" \
  --network-policy=false
