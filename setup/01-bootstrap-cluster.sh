#!/bin/bash

# https://github.com/alexellis/k3sup

echo "Installing Control Node 1"
k3sup install \
    --ip "$K3S_CONTROL_01_IP" \
    --user "$K3S_CLUSTER_USER" \
    --cluster \
    --merge --local-path "$HOME/.kube/config-files/$K3S_CLUSTER_KUBECONFIG_NAME" \
    --k3s-extra-args "--disable-cloud-controller --disable traefik --disable servicelb --disable local-storage" \
    --context "$K3S_CLUSTER_CONTEXT" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Control Node 2"
k3sup join \
    --ip "$K3S_CONTROL_02_IP" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --server-user "$K3S_CLUSTER_USER" \
    --server \
    --k3s-extra-args "--disable-cloud-controller --disable traefik --disable servicelb --disable local-storage" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Control Node 3"
k3sup join \
    --ip "$K3S_CONTROL_03_IP" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --server-user "$K3S_CLUSTER_USER" \
    --server \
    --k3s-extra-args "--disable-cloud-controller --disable traefik --disable servicelb --disable local-storage" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Node NUC 1"
k3sup join \
    --ip "$K3S_NODE_NUC_01" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Node NUC 2"
k3sup join \
    --ip "$K3S_NODE_NUC_02" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Node RPi 1"
k3sup join \
    --ip "$K3S_NODE_RPI_01" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"

echo "Installing Node RPi 2"
k3sup join \
    --ip "$K3S_NODE_RPI_02" \
    --user "$K3S_CLUSTER_USER" \
    --server-ip "$K3S_CONTROL_01_IP" \
    --k3s-version "$K3S_CLUSTER_VERSION" \
    --ssh-key "$K3S_CLUSTER_SSH_KEY_PATH"
