# Volume Resize

You can resize a volume by editing the `spec.resources.requests.storage` field of the PersistentVolumeClaim object.

```bash
kubectl patch pvc <MY-APP>-storage -p '{"spec":{"resources":{"requests":{"storage":"2Gi"}}}}'
```

This will resize the volume to `2Gi`. The volume will be resized when the pod is restarted.