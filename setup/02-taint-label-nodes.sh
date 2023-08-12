#!/bin/bash

# Taint nodes:
# https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/

# kubectl get nodes -o custom-columns=NAME:.metadata.name,TAINTS:.spec.taints --no-headers
kubectl taint nodes k3s-control-01 CriticalAddonsOnly=true:NoSchedule
kubectl taint nodes k3s-control-02 CriticalAddonsOnly=true:NoSchedule
kubectl taint nodes k3s-control-03 CriticalAddonsOnly=true:NoSchedule

kubectl taint nodes k3s-control-01 CriticalAddonsOnly=true:NoSchedule-
kubectl taint nodes k3s-control-02 CriticalAddonsOnly=true:NoSchedule-
kubectl taint nodes k3s-control-03 CriticalAddonsOnly=true:NoSchedule-

# Label nodes:
# https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/
# https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/

# kubectl get nodes --show-labels
kubectl label --overwrite node k3s-node-nuc-01 node-role.kubernetes.io/worker=true
kubectl label --overwrite node k3s-node-nuc-02 node-role.kubernetes.io/worker=true
kubectl label --overwrite node k3s-node-rpi-01 node-role.kubernetes.io/worker=true
kubectl label --overwrite node k3s-node-rpi-02 node-role.kubernetes.io/worker=true

kubectl label --overwrite node k3s-node-nuc-01 node-type=worker
kubectl label --overwrite node k3s-node-nuc-02 node-type=worker
kubectl label --overwrite node k3s-node-rpi-01 node-type=worker
kubectl label --overwrite node k3s-node-rpi-02 node-type=worker

kubectl label --overwrite node k3s-node-nuc-01 node=nuc
kubectl label --overwrite node k3s-node-nuc-02 node=nuc
kubectl label --overwrite node k3s-node-rpi-01 node=raspberry
kubectl label --overwrite node k3s-node-rpi-02 node=raspberry

# unlabel
kubectl label --overwrite node k3s-node-nuc-01 node-type-
kubectl label --overwrite node k3s-node-nuc-02 node-type-
kubectl label --overwrite node k3s-node-rpi-01 node-type-
kubectl label --overwrite node k3s-node-rpi-02 node-type-

# OLD Labels
# This label is to have nice name when running kubectl get nodes:
# kubectl label nodes rpi-k3s-worker-01 kubernetes.io/role=worker
# kubectl label nodes rpi-k3s-worker-02 kubernetes.io/role=worker
# kubectl label nodes rpi-k3s-worker-03 kubernetes.io/role=worker
# kubectl label nodes rpi-k3s-worker-04 kubernetes.io/role=worker
# kubectl label nodes rpi-k3s-worker-05 kubernetes.io/role=worker

# Unlabel:
# kubectl label nodes rpi-k3s-worker-01 kubernetes.io/role-
# kubectl label nodes rpi-k3s-worker-02 kubernetes.io/role-
# kubectl label nodes rpi-k3s-worker-03 kubernetes.io/role-
# kubectl label nodes rpi-k3s-worker-04 kubernetes.io/role-
# kubectl label nodes rpi-k3s-worker-05 kubernetes.io/role-

# Another label/tag. This one I will use to tell deployments to prefer nodes with node-type worker.
# The node-type is our chosen name for value, you can call it whatever:
# kubectl label nodes rpi-k3s-worker-01 node-type=worker
# kubectl label nodes rpi-k3s-worker-02 node-type=worker
# kubectl label nodes rpi-k3s-worker-03 node-type=worker
# kubectl label nodes rpi-k3s-worker-04 node-type=worker
# kubectl label nodes rpi-k3s-worker-05 node-type=worker

# Unlabel:
# kubectl label nodes rpi-k3s-worker-01 node-type-
# kubectl label nodes rpi-k3s-worker-02 node-type-
# kubectl label nodes rpi-k3s-worker-03 node-type-
# kubectl label nodes rpi-k3s-worker-04 node-type-
# kubectl label nodes rpi-k3s-worker-05 node-type-
