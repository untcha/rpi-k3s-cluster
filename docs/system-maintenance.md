## Updating the Node OS

### Cordon the node

``` bash
kubectl cordon <node name>
```

``` bash
kubectl cordon rpi-k3s-master-0
kubectl cordon rpi-k3s-worker-0
```

### Drain the node

``` bash
kubectl drain \
    --ignore-daemonsets \
    --pod-selector='app!=csi-attacher,app!=csi-provisioner' \
    <node name>
```

``` bash
# Necessary on nodes running flux components

kubectl drain \
    --ignore-daemonsets \
    --pod-selector='app!=csi-attacher,app!=csi-provisioner' \
    --delete-emptydir-data \
    <node name>
```

The `--ignore-daemonsets` is needed because Longhorn deployed some daemonsets such as Longhorn manager, Longhorn CSI plugin, engine image. The `--pod-selector='app!=csi-attacher,app!=csi-provisioner'` is needed so CSI Attacher can properly detaches Longhorn volumes

Additional flags:

``` bash
--force
```

!!! note
    TODO:

    ``` bash
    kubectl drain <node-ip> --delete-local-data=false --force=false --grace-period=-1 --ignore-daemonsets=true --timeout=120s
    ```

### Perform the necessary maintenance

``` bash
sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove
```

``` bash
sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove
```

``` bash
sudo reboot
```

### Uncordon the node

``` bash
kubectl uncordon <node name>
```

``` bash
kubectl uncordon rpi-k3s-master-0
kubectl uncordon rpi-k3s-worker-0
```

### Reference
- [Longhorn Node Maintenance Guide](https://longhorn.io/docs/1.2.3/volumes-and-nodes/maintenance/)

## Updating K3S with system-upgrade-controller

### Check for correct node labeling

``` bash
kubectl get node -o wide
```

``` bash
kubectl get node --selector='node-role.kubernetes.io/master'
```

### Label master node if necessary

``` bash
kubectl label node <node name> node-role.kubernetes.io/master=true
```

### Label nodes for upgrade

``` bash
# first time
kubectl label node --all k3s-upgrade=true

# k3s-upgrade=enabled
```

``` bash
kubectl label node --all --overwrite k3s-upgrade=true
```

After the upgrade lable the nodes again:

``` bash
kubectl label node --all --overwrite k3s-upgrade=false
```

### Watch the upgrade

``` ash
watch kubectl get pods -n system-upgrade
```

``` bash
kubectl get pods -n system-upgrade -w
```

!!! note
    TODO:

    ``` bash
    NODES=""
    LABELS="k3s-upgrade=true"
    for NODE in ${NODE_NAMES[*]}; do
        echo ${NODE} ${LABEL}
        kubectl label nodes ${NODE} ${LABEL}
    done
    ```

### Reference
- [gdha/k3s-upgrade-controller](https://github.com/gdha/k3s-upgrade-controller)
- [K3S Upgrade](https://rancher.com/docs/k3s/latest/en/upgrades/)
- [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller)
- [k3s-upgrade](https://github.com/k3s-io/k3s-upgrade)
