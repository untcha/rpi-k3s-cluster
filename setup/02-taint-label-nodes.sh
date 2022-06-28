#!/bin/bash

# Taint nodes:
# https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
# TODO

# Label nodes:
# https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/
# https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/

kubectl label --overwrite node rpi-k3s-worker-01 node-role.kubernetes.io/worker=true
kubectl label --overwrite node rpi-k3s-worker-02 node-role.kubernetes.io/worker=true
kubectl label --overwrite node rpi-k3s-worker-03 node-role.kubernetes.io/worker=true
kubectl label --overwrite node rpi-k3s-worker-04 node-role.kubernetes.io/worker=true
kubectl label --overwrite node rpi-k3s-worker-05 node-role.kubernetes.io/worker=true

kubectl label --overwrite node rpi-k3s-worker-01 node-type=worker
kubectl label --overwrite node rpi-k3s-worker-02 node-type=worker
kubectl label --overwrite node rpi-k3s-worker-03 node-type=worker
kubectl label --overwrite node rpi-k3s-worker-04 node-type=worker
kubectl label --overwrite node rpi-k3s-worker-05 node-type=worker

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
