# How to push metrics

This how-to guide shows you how to use pushgateway for jobs which cannot be scraped.
Further details can be found [here](https://prometheus.io/docs/instrumenting/pushing/)

### Example

=== "naisjob.yaml"

    ```yaml
    apiVersion: nais.io/v1
    kind: Naisjob
    metadata:
      labels:
        team: myteam
      name: myjob
      namespace: myteam
    spec:
      image: europe-north1-docker.pkg.dev/[mgmt-id]/[team-name]/[image-name]:tag
      schedule: "*/1 * * * *"
      env:
        - name: PUSH_GATEWAY_ADDRESS
          value: prometheus-pushgateway.nais-system:9091
      accessPolicy:
        outbound:
          rules:
            - application: prometheus-pushgateway
              namespace: nais-system
    ```

=== "PushMetrics.java"

    ```java
    package io.prometheus.client.it.pushgateway;

    import io.prometheus.client.CollectorRegistry;
    import io.prometheus.client.Gauge;
    import io.prometheus.client.exporter.BasicAuthHttpConnectionFactory;
    import io.prometheus.client.exporter.PushGateway;

    public class ExampleBatchJob {
        public static void main(String[] args) throws Exception {
            String jobName = "my_batch_job";
            String pushGatewayAddress = System.getenv("PUSH_GATEWAY_ADDRESS");

            CollectorRegistry registry = new CollectorRegistry();
            Gauge duration = Gauge.build()
                    .name("my_batch_job_duration_seconds")
                    .help("Duration of my batch job in seconds.")
                    .register(registry);
            Gauge.Timer durationTimer = duration.startTimer();
            try {
                Gauge lastSuccess = Gauge.build()
                        .name("my_batch_job_last_success")
                        .help("Last time my batch job succeeded, in unixtime.")
                        .register(registry);
                lastSuccess.setToCurrentTime();
            } finally {
                durationTimer.setDuration();
                PushGateway pg = new PushGateway(pushGatewayAddress);
                pg.pushAdd(registry, jobName);
            }
        }
    }
    ```