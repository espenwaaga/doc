# Metrics reference

## Retention

When using Prometheus the retention is 4 weeks.
If you need data stored longer than what Prometheus support, we recommend using [BigQuery](../persistence/bigquery.md) or your own [Aiven Influxdb](../persistence/influxdb.md).
Then you have full control of the database and retention.

## Prometheus Environments (TODO: per tenant)

**GCP**

- [prometheus.dev-gcp.nav.cloud.nais.io](https://prometheus.dev-gcp.nav.cloud.nais.io)
- [prometheus.prod-gcp.nav.cloud.nais.io](https://prometheus.prod-gcp.nav.cloud.nais.io)

**On-prem**

- [prometheus.dev-fss.nav.cloud.nais.io](https://prometheus.dev-fss.nav.cloud.nais.io)
- [prometheus.prod-fss.nav.cloud.nais.io](https://prometheus.prod-fss.nav.cloud.nais.io) :octicons-shield-lock-16:

:octicons-shield-lock-16: requires `onprem-k8s-prod` gateway in `naisdevice`.
