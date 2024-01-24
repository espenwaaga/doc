# Connecting to the Dataset
When connecting your BigQuery client you need to specify the project ID and the dataset ID.
The project ID is available in the `GCP_TEAM_PROJECT_ID` environment variable.
There's no automatic environment variable for the dataset ID.

```kotlin
val projectId = System.getenv("GCP_TEAM_PROJECT_ID")
val datasetId = "my_bigquery_dataset"
val bigQueryClient = BigQueryClient.create(projectId, datasetId)
```
# Troubleshooting
If you have problems getting your bucket up and running, check errors in the event log:

```bash
kubectl describe bigquerydataset my-bigquery-dataset
```