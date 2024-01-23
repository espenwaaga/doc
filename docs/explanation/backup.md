---
description: Backup and restore of all resources in the cluster provided by Velero.
---

# Backup of cluster resources

This feature is installed on all on-prem and GCP clusters. Velero is a product that includes features for backing up and restoring resources in kubernetes clusters. The backups are run every second hour on all clusters by the Velero schedule. Velero saves backups to gcp buckets and supports restores of specific resources or namespaces. All namespaces are backed up. The solution also creates snapshots of the persistent volumes in kubernetes.

See also [Velero documentation](https://velero.io/docs/main/how-velero-works/)

If you need something restored or have any questions about velero please contact the nais team on the [nais slack channel](https://nav-it.slack.com/messages/C5KUST8N6) or contact [@Sten.Ivar.Røkke](https://nav-it.slack.com/archives/D5KP2068Z) for more information.

# Backup of buckets (TODO)

# Backup of databases (TODO)
