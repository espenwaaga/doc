# How to expose metrics

This guide will show you how to expose metrics from your application, and how to configure Prometheus to scrape them.

See further [explanations on metrics] (/explanation/metrics) for more details

## 1. Enable metrics in [manifest](../../../reference/application-spec.md)

```yaml
spec:
  prometheus:
  enabled: true # default: false. Pod will now be scraped for metrics by Prometheus.
  path: /metrics # Path where prometheus metrics are served.
```

## 2. Add metric to your application

??? info "Links to various client libraries"

    There are a number of client libraries available depending on what programming language you are using. You can use these to simplify the communication with Prometheus.

    * [Prometheus Java client](https://github.com/prometheus/client_java)
    * [Prometheus Python client](https://github.com/prometheus/client_python)
    * [Prometheus Go client](https://github.com/prometheus/client_golang)
    * [Prometheus Node.js client](https://github.com/siimon/prom-client)

    You can find a [comprehensive list of client libraries](https://prometheus.io/docs/instrumenting/clientlibs/) here

### Default metrics

Most of the client libraries (see list above), includes libraries for generating default metrics like garbage collection, memory pools, classloading, and thread counts. Using these metrics will ensure that your metrics are named in a certain convention, making it more easy to compare across applications.

=== "JAVA"

    ```java
    import io.prometheus.client.hotspot.DefaultExports;
    Class YourClass {
      public static void main(String[] args) {
          DefaultExports.initialize()
      }
    }
    ```

=== "Node.js"

    ```js
    const client = require('prom-client');
    const collectDefaultMetrics = client.collectDefaultMetrics;
    const Registry = client.Registry;
    const register = new Registry();
    collectDefaultMetrics({ register });
    ```

=== "Python"

    ```python
    from prometheus_client import start_http_server, Summary
    prometheus_client.start_http_server(8000)
    ```

=== "Go"

    ```go
    import (
      "log"
      "net/http"
      "github.com/prometheus/client_golang/prometheus"
      "github.com/prometheus/client_golang/prometheus/promhttp"
    )

    func main() {
      http.Handle("/metrics", promhttp.Handler())
      log.Fatal(http.ListenAndServe(":8080", nil))
    }
    ```

## 3. Add custom metrics (optional)

=== "Counter.java"

    Counters go up, and reset when the process restarts.

    ```java
    import io.prometheus.client.Counter;
    class YourClass {
      static final Counter requests = Counter.build()
        .name("requests_total").help("Total requests.").register();

      void processRequest() {
        requests.inc();
        // Your code here.
      }
    }
    ```

=== "Gauge.java"

    Gauges can go up and down.

    ```java
    import io.prometheus.client.Gauge;
    class YourClass {
      static final Gauge inprogressRequests = Gauge.build()
        .name("inprogress_requests").help("Inprogress requests.").register();

      void processRequest() {
        inprogressRequests.inc();
        // Your code here.
        inprogressRequests.dec();
      }
    }
    ```

    There are utilities for common use cases:

    ```java
    gauge.setToCurrentTime(); // Set to current unixtime.
    ```

=== "Summary.java"

    Summary metrics calculate quantiles (e.g. the 99th percentile request latency).  Note that summaries cannot be aggregated.

    ```java
    import io.prometheus.client.Summary;
    class YourClass {
      static final Summary requestLatency = Summary.build()
        .name("requests_latency_seconds").help("Request latency in seconds.").register();

      void processRequest() {
        Summary.Timer requestTimer = requestLatency.startTimer();
        // Your code here.
        requestTimer.observeDuration();
      }
    }
    ```
