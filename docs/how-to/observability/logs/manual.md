# Sending logs with HTTP

This guide will show you how to send logs to Elasticsearch using HTTP.

If you do not want to have these logs as files in the pod, it is also possible to use HTTP to write logs. POST your log entry as JSON to `http://localhost:19880`

```bash
curl -X POST -d '{"log":"hello world","field1":"value1"}' -H 'Content-Type: application/json' http://localhost:19880/
```