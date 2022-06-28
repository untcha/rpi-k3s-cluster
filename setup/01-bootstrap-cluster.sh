#!/bin/bash

# https://github.com/alexellis/k3sup

echo "Installing Master 1"
k3sup install \
    --ip $K3S_CLUSTER_IP_M01 \
    --user $K3S_CLUSTER_USER \
    --cluster \
    --merge --local-path $HOME/.kube/config-files/$K3S_CLUSTER_KUBECONFIG_NAME \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --context $K3S_CLUSTER_CONTEXT \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Master 2"
k3sup join \
    --ip $K3S_CLUSTER_IP_M02 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --server-user $K3S_CLUSTER_USER \
    --server \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Master 3"
k3sup join \
    --ip $K3S_CLUSTER_IP_M03 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --server-user $K3S_CLUSTER_USER \
    --server \
    --k3s-extra-args "--disable traefik --disable servicelb --disable local-storage" \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Worker 1"
k3sup join \
    --ip $K3S_CLUSTER_IP_W01 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Worker 2"
k3sup join \
    --ip $K3S_CLUSTER_IP_W02 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Worker 3"
k3sup join \
    --ip $K3S_CLUSTER_IP_W03 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Worker 4"
k3sup join \
    --ip $K3S_CLUSTER_IP_W04 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH

echo "Installing Worker 5"
k3sup join \
    --ip $K3S_CLUSTER_IP_W05 \
    --user $K3S_CLUSTER_USER \
    --server-ip $K3S_CLUSTER_IP_M01 \
    --k3s-version $K3S_CLUSTER_VERSION \
    --ssh-key $K3S_CLUSTER_SSH_KEY_PATH
