#!/bin/bash

echo Installing Server 1
k3sup install \
    --ip $K3S_CLUSTER_IP_M01 \
    --user $K3S_CLUSTER_USER \
    --cluster \
    --merge --local-path $HOME/.kube/config-files/$K3S_CLUSTER_KUBECONFIG_NAME \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --context $K3S_CLUSTER_CONTEXT \
    --ssh-key "~/.ssh/id_rsa" \
    --k3s-version $K3S_CLUSTER_VERSION


echo Installing Server 2
k3sup join \
    --ip $K3S_CLUSTER_IP_M02 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --server-user $K3S_CLUSTER_USER \
    --server \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --ssh-key "~/.ssh/id_rsa" \
    --k3s-version $K3S_CLUSTER_VERSION

echo Installing Server 3
k3sup join \
    --ip $K3S_CLUSTER_IP_M03 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --server-user $K3S_CLUSTER_USER \
    --server \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --ssh-key "~/.ssh/id_rsa" \
    --k3s-version $K3S_CLUSTER_VERSION

echo Installing Worker 1
k3sup join \
    --ip $K3S_CLUSTER_IP_W01 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --ssh-key "~/.ssh/id_rsa" \
    --k3s-version $K3S_CLUSTER_VERSION

# echo Installing Worker 2
# k3sup join \
#     --ip $K3S_CLUSTER_IP_W02 \
#     --user $K3S_CLUSTER_USER \
#     --server-ip $K3S_CLUSTER_IP_M01 \
#     --ssh-key "~/.ssh/id_rsa" \
#     --k3s-version $K3S_CLUSTER_VERSION

# echo Installing Worker 3
# k3sup join \
#     --ip $K3S_CLUSTER_IP_W03 \
#     --user $K3S_CLUSTER_USER \
#     --server-ip $K3S_CLUSTER_IP_M01 \
#     --ssh-key "~/.ssh/id_rsa" \
#     --k3s-version $K3S_CLUSTER_VERSION

# echo Installing Worker 4
# k3sup join \
#     --ip $K3S_CLUSTER_IP_W04 \
#     --user $K3S_CLUSTER_USER \
#     --server-ip $K3S_CLUSTER_IP_M01 \
#     --k3s-version $K3S_CLUSTER_VERSION

#source ~/.zshrc

# Install 'kubernetes-dashboard'
#echo Installing kubernetes-dashboard
#arkade install kubernetes-dashboard

# Create 'flux-system' namespace
#echo Creating flux-system namespace
#kubectl create namespace flux-system

# Create 

# Add the Flux GPG key in-order for Flux to decrypt SOPS secrets
# TODO: place encrypted sops-gpg.yaml in the repository
# gpg --export-secret-keys --armor "${FLUX_KEY_FP_TESTING}" |
# kubectl create secret generic sops-gpg \
#     --namespace=flux-system \
#     --from-file=sops.asc=/dev/stdin
