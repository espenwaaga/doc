# Workload CRUD-operations

This guide shows you how to perform CRUD-operations on your workload.

## 0. Prerequisites
- [Command-line access to the cluster](command-line-access.md)
- [Member of a NAIS team](../explanation/nais-teams.md)
- [Container image uploaded to the OCI registry](TODO)
- [Workload spec](../explanation/workloads.md)

=== "Application"

    ## 1. Create/apply the application spec
    
    ```shell
    kubectl apply -f nais.yaml --namespace=<your team namespace> --context=<your cluster>
    ```

    Verify that the application was successfully created by running `describe` on the Application:

    ```shell
    kubectl describe app <my app>
    ```

    The events will tell you if the application was successfully created or not.


    ## 2. Read/list your applications

    ```shell
    kubectl get application --namespace=<your team namespace> --context=<your cluster>
    ```

    ## 3. Update/edit your application
    
    ```shell
    kubectl edit application <your app> --namespace=<your team namespace> --context=<your cluster>
    ```
    
    ## 4. Delete your application
    
    ```shell
    kubectl delete application <your app> --namespace=<your team namespace> --context=<your cluster>
    ```

=== "Naisjob"

    ## 1. Create/apply the naisjob spec
    
    ```shell
    kubectl apply -f nais.yaml --namespace=<your team namespace> --context=<your cluster>
    ```

    Verify that the naisjob was successfully created by running `describe` on the Naisjob:

    ```shell
    kubectl describe naisjob <my naisjob>
    ```

    The events will tell you if the naisjob was successfully created or not.

    ## 2. Read/list your naisjobs

    ```shell
    kubectl get naisjob --namespace=<your team namespace> --context=<your cluster>
    ```

    ## 3. Update/edit your naisjob
    
    ```shell
    kubectl edit naisjob <your naisjob> --namespace=<your team namespace> --context=<your cluster>
    ```

    ## 4. Delete your naisjob
    
    ```shell
    kubectl delete naisjob <your naisjob> --namespace=<your team namespace> --context=<your cluster>
    ```
