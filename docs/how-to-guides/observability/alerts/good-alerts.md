# How to write a good alert

## Writing the `expr`

In order to figure out what is a valid expression we suggest using [Grafana > Explore](https://grafana.nais.io/explore). It has a graphical user interface with a "builder" mode where you can select from from drop-down lists of valid values.

In order to further minimize the feedback loop we suggest experimenting on the Prometheus server to find the right metric for your alert and the notification threshold.
The Prometheus server can be found in each cluster, at `https://prometheus.{env}.nav.cloud.nais.io` (e.g. [https://prometheus.dev-gcp.nav.cloud.nais.io](https://prometheus.dev-gcp.nav.cloud.nais.io)).

You can also visit the Alertmanager at `https://alertmanager.{env}.nav.cloud.nais.io` (e.g. [https://alertmanager.dev-gcp.nav.cloud.nais.io](https://alertmanager.dev-gcp.nav.cloud.nais.io)) to see which alerts are triggered now (you can also silence already triggered alerts).

## `for`

How long time the `expr` must evaluate to `true` before firing.

When the `expr` first evaluates to `true` the alert will be in `pending` state for the duration specified.

Example values: `30s`, `5m`, `1h`.

## Severity

This will affect what color the notification gets. Possible values are `critical` (red), `warning` (yellow) and `notice` (green).

## Consequence

Optionally describe ahead of time to the one receiving the alert what happens in the world when this alert fires.

## Action

Optionally describe ahead of time to the one receiving the alert what is the best course of action to resolve this issue.

## Summary

Optional longer description of the alert



## Onprem (TODO)

For Custom AlertmanagerConfig in the onprem clusters, calling external webhooks like Slack will require you to configure the webhook to use proxy:

```
httpConfig:
  proxyURL: http://webproxy.nais:8088
```
