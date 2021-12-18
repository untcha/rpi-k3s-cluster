## Updating the Node OS

### Cordon the node

```bash
kubectl cordon <node name>
```

### Drain the node

```bash
kubectl drain <node-name> --ignore-daemonsets --pod-selector='app!=csi-attacher,app!=csi-provisioner'
```

The `--ignore-daemonsets` is needed because Longhorn deployed some daemonsets such as Longhorn manager, Longhorn CSI plugin, engine image. The `--pod-selector='app!=csi-attacher,app!=csi-provisioner'` is needed so CSI Attacher can properly detaches Longhorn volumes

Additional flags:

```bash
--force
```

```bash
--delete-emptydir-data
```

### Perform the necessary maintenance

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
