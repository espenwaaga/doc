# Create a bucket

You create a Google Cloud Storage bucket through the NAIS application manifest.

```yaml
apiVersion: nais.io/v1alpha1
kind: Application
metadata:
  name: myapp
...
spec:
  ...
  gcp:
    buckets:
      - name: mybucket
        retentionPeriodDays: 30
        lifecycleCondition:
          age: 7
          createdBefore: 2020-01-01
          numNewerVersions: 2
          withState: ANY
```

!!! info
    Once a bucket is provisioned, it will not be automatically deleted unless one explicitly sets `spec.gcp.buckets[].cascadingDelete` to `true`. This means that any cleanup must be done manually. If `spec.gcp.buckets[].cascadingDelete` is set to `true` and the bucket contains files, the bucket will not be deleted.

Bucket names must be globally unique across the entire Google infrastructure. This can cause provisioning problems if your bucket name is used by someone else.