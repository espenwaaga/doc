# Create a Kafka topic
This guide will show you how to create a Kafka topic

## 1. Creating topics

???+ note ".nais/topic.yaml"
    ```yaml hl_lines="4-5 7 9 11-14"
    apiVersion: kafka.nais.io/v1
    kind: Topic
    metadata:
      name: <MY-TOPIC>
      namespace: <MY-TEAM>
      labels:
        team: <MY-TEAM>
    spec:
      pool: <MY-POOL> # TODO: link to available tenant pools
      acl:
        - team: <MY-TEAM>
          application: <MY-APP>
          access: readwrite   # read, write, readwrite
    ```
See the [Kafka topic reference](../../../reference/kafka-topic-spec.md) for a complete list of available options.

## 2. Grant access to the topic for other applications (optional)
See [manage access](manage-acl.md) for how to grant access to your topic.

## 3. Apply the Topic resource
=== "Automatically"
    Add the file to your application repository to deploy with [NAIS github action](../../cicd/github-action.md).
=== "Manually"
    ```bash
    kubectl apply -f ./nais/topic.yaml --namespace=<MY-TEAM> --context=<MY-CLUSTER>
    ```
