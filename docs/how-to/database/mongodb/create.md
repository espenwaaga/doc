# MongoDB in GKE

!!! info "Disclaimer"
    Nais does not support MongoDB in GKE, however one can easily set up one manually. Your team is responsible for maintenance and upgrades.

## 1. Create your MongoDB-instance
 The following example creates an instance with three replicas using a pre-existing storage-class for an example volume `<MY-APP>` with a volume of `1Gi`. The storage-class is a cluster-wide resource. 

???+ note ".nais/statefulset.yaml"

    ```yaml hl_lines="4 5 7 11 15 18"
    apiVersion: apps/v1
    kind: StatefulSet
    metadata:
    name: <MY-MONGODB>
    namespace: <MY-TEAM>
    spec:
    serviceName: <MY-MONGODB>
    replicas: 3
    selector:
        matchLabels:
        role: <MY-MONGODB>    
    template:
        metadata:
        labels:
            role: <MY-MONGODB>
            environment: test
            replicaset: MainRepSet
            app: <MY-MONGODB>
        spec:
        terminationGracePeriodSeconds: 10
        containers:
            - name: mongod-container
            image: mongo:5
            command:
                - "mongod"
                - "--bind_ip"
                - "0.0.0.0"
                - "--replSet"
                - "MainRepSet"
            resources:
                requests:
                cpu: 0.2
                memory: 1.25Gi
            ports:
                - containerPort: 27017
            volumeMounts:
                - name: mongodb-persistent-storage-claim
                mountPath: /data/db
    volumeClaimTemplates:
        - metadata:
            name: mongodb-persistent-storage-claim
            annotations:
            volume.beta.kubernetes.io/storage-class: "ssd-storage"
        spec:
            accessModes: [ "ReadWriteOnce" ]
            resources:
            requests:
                storage: 1Gi
    ```

## 2.  Allow traffic from your application to MongoDB-instance

### 2.1 Create a network policy

???+ note ".nais/networkpolicy.yaml"

    ``` yaml
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
    labels:
    app: <MY-MONGODB>
    team: <MY-TEAM>
    name: <MY-MONGODB>
    namespace: <MY-TEAM>
    spec:
    egress:
    - to:
        - namespaceSelector:
            matchLabels:
                linkerd.io/is-control-plane: "true"
        - namespaceSelector: {}
            podSelector:
            matchLabels:
                role: <MY-MONGODB>
        - namespaceSelector: {}
            podSelector:
            matchLabels:
                k8s-app: kube-dns
        - ipBlock:
            cidr: 0.0.0.0/0
            except:
                - 10.6.0.0/15
                - 172.16.0.0/12
                - 192.168.0.0/16
    ingress:
    - from:
        - namespaceSelector:
            matchLabels:
                kubernetes.io/metadata.name: nais
            podSelector:
            matchLabels:
                app: prometheus
    - from:
        - namespaceSelector:
            matchLabels:
                kubernetes.io/metadata.name: <MY-TEAM>
            podSelector:
            matchLabels:
                app: <MY-APP>
    - from:
        - namespaceSelector: {}
            podSelector:
            matchLabels:
                role: <MY-MONGODB>
    - from:
        - namespaceSelector:
            matchLabels:
                linkerd.io/is-control-plane: "true"
    - from:
        - namespaceSelector:
            matchLabels:
                linkerd.io/extension: viz
            podSelector:
            matchLabels:
                component: tap
    - from:
        - namespaceSelector:
            matchLabels:
                linkerd.io/extension: viz
            podSelector:
            matchLabels:
                component: prometheus
    podSelector:
    matchLabels:
        role: <MY-MONGODB>
    policyTypes:
    - Ingress
    - Egress
    ```

### 2.2 Create a service for your MongoDB-instance

???+ note ".nais/service.yaml"

    ``` yaml
    apiVersion: v1
    kind: Service
    metadata:
    name: <MY-MONGODB>
    namespace: <MY-TEAM>
    labels:
        name: <MY-MONGODB>
    spec:
    ports:
        - port: 27017
        targetPort: 27017
    clusterIP: None
    selector:
        role: <MY-MONGODB>
    ```

### 2.3 Define an accessPolicy

???+ note ".nais/application.yaml"
    
    ``` yaml
    apiVersion: "nais.io/v1alpha1"
    kind: "Application"
    metadata:
    name: <MY-APP>
    namespace: <MY-TEAM>
    labels:
        team: <MY-TEAM>
    spec:
    accessPolicy:
        outbound:
        rules:
        - application: <MY-MONGODB>
    env:
    - name: MONGODB_URL
        value: mongodb://<MY-MONGODB>-0.<MY-MONGODB>:27017,<MY-MONGODB>-1.<MY-MONGODB>:27017,<MY-MONGODB>-2.my-mongo:27017/deploy_log?replicaSet=MainRepSet
    ```