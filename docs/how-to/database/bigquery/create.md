# Create an instance of BigQuery

Below you'll se a minimal working example for a NAIS Application manifest.

???+ note ".nais/application.yaml"

    ```yaml
    apiVersion: "nais.io/v1alpha1"
    kind: "Application"
    metadata:
      name: app-a
    ...
    spec:
      ...
      gcp:
        bigQueryDatasets:
          - name: my_bigquery_dataset
            permission: READWRITE
    ```