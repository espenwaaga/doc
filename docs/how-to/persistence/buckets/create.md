# How to create a bucket

## 1. Choose a name for the bucket

Bucket names must be globally unique across the entire Google infrastructure. If your bucket name is used by someone else, you can get provisioning problems.

## 2. Add the bucket to the NAIS application manifest

You create a Google Cloud Storage bucket through the NAIS application manifest. 

```yaml
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  name: <MY-APP>
...
spec:
  ...
  gcp:
    buckets:
      - name: <MY-BUCKET>
        retentionPeriodDays: 30
        lifecycleCondition:
          age: 7
          createdBefore: 2020-01-01
          numNewerVersions: 2
          withState: ANY
```
`retentionPeriodDays` and `lifecycleCondition` are for neccessary for [backup](../../reference/bucket-backup.md).

## 3. Enable automatic deletion

To avoid incurring unnecessary costs, set your bucket to be automatically deleted. This cascades application deletion to the bucket - unless it contains files. 

Add `cascadingDelete` and set it to `true` in your NAIS application spesification. 

```yaml hl_lines="11"
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  name: <MY-APP>
...
spec:
  ...
  gcp:
    buckets:
      - name: <MY-BUCKET>
        cascadingDelete: true
        retentionPeriodDays: 30
        lifecycleCondition:
          age: 7
          createdBefore: 2020-01-01
          numNewerVersions: 2
          withState: ANY
```

## 4. Problem solving

If you have problems getting your bucket up and running, check errors in [Console](https://console.@@TENANT@@.cloud.nais.io). Navigate to your app <MY-APP> and check the Logs tab.

Alternative:

```bash
kubectl describe storagebucket <MY-BUCKET>
```

## 5. Example application

An example application using workflow identity to access a bucket: [testapp](https://github.com/nais/testapp)
