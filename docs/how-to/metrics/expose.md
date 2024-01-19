# How to expose metrics

Bellow we have a few samples to get you started. For more in-depth examples and reference, check out the documentation for your specific client.

## 1. Enable metrics in [manifest](TODO:reference-et-eller-annet)

```yaml
spec:
    prometheus:
    enabled: true  # default: false. Pod will now be scraped for metrics by Prometheus.
    path: /metrics # Path where prometheus metrics are served.
```
## 2. Add metric to your application

??? info "Client libraries"
    There are a number of client libraries available depending on what programming language you are using. You can use these to simplify the communication with Prometheus.

    * [Prometheus Java client][prometheus-client-java]
    * [Prometheus Python client][prometheus-client-python]
    * [Prometheus Go client][prometheus-client-go]
    * [Prometheus Node.js client][prometheus-client-node]

    You can find a comprehensive list of [client libraries here][prometheus-clients-all].

    [prometheus-client-java]: https://github.com/prometheus/client_java
    [prometheus-client-python]: https://github.com/prometheus/client_python
    [prometheus-client-go]: https://github.com/prometheus/client_golang
    [prometheus-client-node]: https://github.com/siimon/prom-client
    [prometheus-clients-all]: https://prometheus.io/docs/instrumenting/clientlibs/

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


## 3. Example metrics

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