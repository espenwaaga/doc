# Persistent Volume Storage

Volume storage is a storage solution based on Kubernetes [PV][k8s-pv] and [PVC][k8s-pvc] used for persistent storage. This creates a disk that is attached to the cluster and can be mounted as a volume in a pod.

[k8s-pv]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/
[k8s-pvc]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims

Volume storage is considered a last resort for storage and only if the existing other storage solutions are not suitable for your use case. Please make sure you have considered [all other options](./README.md) first.

## Limitations

Volume storage has the following limitations:

 * Only available in GCP.
 * There is no automatic backup and restore of data.
 * There is no automatic scaling of the volume size.
 * A volume can only be mounted to one pod at a time. Which means that if you have multiple pods they can not share a single volume.

    It also means that if you have only one instance it needs to be completely stopped before a new instance can be started with the same volume resulting in downtime.

Even though you can request very large volumes, it is not a good solution for storing large amounts of data. We do not recommended storing more than 100GB of data in a single volume.