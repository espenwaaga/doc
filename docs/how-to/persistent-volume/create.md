# Create a persistent volume storage

An example app <MY-APP> with a volume of `1Gi`:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: <MY-APP>
spec:
  serviceName: <MY-APP>
  replicas: 1
  selector:
    matchLabels:
      app: <MY-APP>
  template:
    metadata:
      labels:
        app: <MY-APP>
    spec:
      containers:
      - name: <MY-APP>
        image: <MY-APP>:latest
        volumeMounts:
        - name: <MY-APP>-storage
          mountPath: /data
  volumeClaimTemplates:
  - metadata:
      name: <MY-APP>-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

## Storage classes

By default, dynamically provisioned `PersistentVolumes` use the `default` `StorageClass` and are backed by standard hard disks. If you need faster SSDs, you can use the `ssd-storage` storage class.

To set the storage class for a volume, add the `storageClassName` field to the `PersistentVolumeClaim`:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: <MY-APP>
spec:
  ...
  volumeClaimTemplates:
  - metadata:
      name: <MY-APP>-storage
    spec:
      storageClassName: ssd-storage
      ...
```

## Volume Snapshot

In Kubernetes, a VolumeSnapshot represents a snapshot of a volume on a storage system. We recommend you to already be familiar with Kubernetes persistent volumes before using this.

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: new-snapshot-test
spec:
  volumeSnapshotClassName: csi-hostpath-snapclass
  source:
    persistentVolumeClaimName: pvc-test
```