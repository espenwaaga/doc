# Azure AD 
This guide shows you how to enable Azure AD authentication and authorization for your application.

## 1. Enable Azure AD authentication
???+ note ".nais/app.yaml"
    ```yaml hl_lines="4-5 7 9 11-14"
    apiVersion: nais.io/v1alpha1
    kind: Application
    metadata:
      name: <MY-APP>
      namespace: <MY-TEAM>
      labels:
          team: <MY-TEAM>
    spec:
      azure:
        application:
          enabled: true

      # optional, only relevant if your application receives requests from consumers
      accessPolicy:
        inbound:
          rules:
            - application: <OTHER-APP>
              namespace: <OTHER-TEAM>
              cluster: <OTHER-ENV>

      # required for on-premises only (TODO: NAV ONLY)
      webproxy: true 
    ```
See the complete specification in the [Application manifest](../../../reference/application-spec.md#azure).

## 2. Apply the application
=== "Automatically"
    Add the file to your application repository to deploy with [NAIS github action](../../cicd/github-action.md).
=== "Manually"
    ```bash
    kubectl apply -f ./nais/app.yaml --namespace=<MY-TEAM> --context=<MY-CLUSTER>
    ```

!!! warning
    No access is granted by default.
    You must explicitly [grant access to users](./access-user.md).
    You must explicitly grant applications access by [pre-authorizing](./access-application.md) them.
