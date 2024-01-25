# Applications

This guide will show you how to grant other applications access to your application.

## 1. Add permitted audience

```yaml
spec:
  accessPolicy:
    inbound:
      rules:
        - application: <OTHER-APP> # an application in the same namespace and cluster

        - application: <OTHER-APP> 
          namespace: <OTHER-NAMESPCE> # an application in the same cluster, but different namespace

        - application: <OTHER-APP>
          namespace: <OTHER-NAMESPACE>
          cluster: <OTHER-CLUSTER> # an application in a different cluster
```


!!! warning

    - These rules are _eventually consistent_, which means they might take a few minutes to fully propagate.

You can also configure [more fine-grained access control](./fine-grained.md)

## 2. Apply the Application resource
TODO