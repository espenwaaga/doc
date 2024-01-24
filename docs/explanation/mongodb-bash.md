# MongoDB bash job for backup

The following bash script will create a gzipped dump of my-mongodb-0, which then will be uploaded to the GCP storage bucket of your choice. In production, the buckets will be archived on-premises as well. 
``` shell 
#!/usr/bin/env bash

if ! kubectl exec -it -n aura my-mongodb-0 -c mongod-container -- mongodump --archive --gzip > ./dump.gz; then
  echo "failed to execute mongodump"
  exit 1
fi

backup_name="dump_$(date +"%Y-%m-%d_%H-%M").tgz"
if ! gsutil mv "./dump.gz" "gs://<backup-bucket-name>/$backup_name"; then
  echo "failed to upload backup to bucket"
  exit 1
fi

rm dump.gz
```
