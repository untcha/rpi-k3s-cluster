#!/bin/bash

echo "Create flux-system namespace"
kubectl create namespace flux-system

echo "Create flux secret"
gpg --export-secret-keys --armor "${FLUX_KEY_FP}" |
kubectl create secret generic sops-gpg \
    --namespace=flux-system \
    --from-file=sops.asc=/dev/stdin

echo "Bootstrap GitHub and deploy workload"
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=$GITHUB_REPOSITORY \
  --branch=main \
  --path=./cluster/base \
  --version=$FLUX_VERSION \
  --network-policy=false
