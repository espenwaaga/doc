# Customizing

Each team namespace will have a default `AlertmanagerConfig` which will pickup alerts labeled `namespace: <team namespace>`. If you want to change anything about alerting for your team, e.g. the formatting of alerts, webhook used, ..., you can create a simular `AlertmanagerConfig` which is configured for different labels:

```
route:
  matchers:
    - name: team
      value: myteam
      matchType: =
    - name: app
      value: myapp
      matchType: =
```

Remember that these matchers will match against every alert in the cluster, so be sure to use values that will be unique for your team.  
In your `PrometheusRule` also include the label `alert_type: custom` to be sure the default configuration doesn't pickup your alert.

For more information about `slackConfigs` and other posibilites see the [Prometheus alerting documentation](https://prometheus.io/docs/alerting/latest/configuration/#slack_config).