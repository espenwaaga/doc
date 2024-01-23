# Recording rules

This guide will show you how to create a recording rule

Recording rules allow you to precompute frequently needed or computationally expensive expressions and save
their result as a new set of time series. Querying the precomputed result will then often be much faster
than executing the original expression every time it is needed.

1. Create RecordingRule

```yaml hl_lines="4-5 29"
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: <MY-ALERT>
  namespace: <MY-TEAM>
spec:
  groups:
    - name: example-with-record-alerts
      rules:
        - record: is_european_summer_time
          expr: |
            (vector(1) and (month() > 3 and month() < 10))
            or
            (vector(1) and (month() == 3 and (day_of_month() - day_of_week()) >= 25) and absent((day_of_month() >= 25) and (day_of_week() == 0)))
            or
            (vector(1) and (month() == 10 and (day_of_month() - day_of_week()) < 25) and absent((day_of_month() >= 25) and (day_of_week() == 0)))
            or
            (vector(1) and ((month() == 10 and hour() < 1) or (month() == 3 and hour() > 0)) and ((day_of_month() >= 25) and (day_of_week() == 0)))
            or
            vector(0)
        - record: european_time
          expr: time() + 3600 * (is_european_summer_time + 1)
        - record: european_hour
          expr: hour(european_time)
        - alert: QuietHours
          expr: european_hour >= 23 or european_hour <= 6
          for: 5m
          labels:
            namespace: <MY-TEAM>
            severity: critical
          annotations:
            description: "This alert fires during quiet hours. It should be blackholed by Alertmanager."
```
