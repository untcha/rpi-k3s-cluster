## Updating the Node OS

### Cordon the node

```bash
kubectl cordon <node name>
```

```bash
kubectl cordon rpi-k3s-master-0
kubectl cordon rpi-k3s-worker-0
```

### Drain the node

```bash
kubectl drain \
    --ignore-daemonsets \
    --pod-selector='app!=csi-attacher,app!=csi-provisioner' \
    <node name>
```

```bash
# Necessary on nodes running flux components

kubectl drain \
    --ignore-daemonsets \
    --pod-selector='app!=csi-attacher,app!=csi-provisioner' \
    --delete-emptydir-data \
    <node name>
```

The `--ignore-daemonsets` is needed because Longhorn deployed some daemonsets such as Longhorn manager, Longhorn CSI plugin, engine image. The `--pod-selector='app!=csi-attacher,app!=csi-provisioner'` is needed so CSI Attacher can properly detaches Longhorn volumes

Additional flags:

```bash
--force
```

TODO:

```bash
kubectl drain <node-ip> --delete-local-data=false --force=false --grace-period=-1 --ignore-daemonsets=true --timeout=120s
```

### Perform the necessary maintenance

```bash
sudo apt update && sudo apt upgrade && sudo apt -y autoremove
```

```bash
sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove
```

```bash
sudo reboot
```

### Uncordon the node

```bash
kubectl uncordon <node name>
```

```bash
kubectl uncordon rpi-k3s-master-0
kubectl uncordon rpi-k3s-worker-0
```
