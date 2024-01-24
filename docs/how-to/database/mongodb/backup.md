## Backup of MongoDB-instance

NAIS doesn't provide any backup solution for MongoDB-instances, but you can easily set up cronjob for backup purposes. To set up your backup job you need a Naisjob bundling your bash script, a NetworkPolicy and RBAC resources as described below. In the examples below volume `<MY-APP>` has a volume of `1Gi`.

## 1. Create a naisjob building your bash script 

???+ note ".nais/naisjob.yaml"
   
    ```yaml 
    apiVersion: nais.io/v1
    kind: Naisjob
    metadata:
      labels:
        team: <MY-TEAM>
      name: <MY-BACKUP>
      namespace: <MY-TEAM>
    spec:
      activeDeadlineSeconds: 6000
      backoffLimit: 5
      failedJobsHistoryLimit: 2
      gcp:
        buckets:
          - cascadingDelete: false
            name: <MY-BACKUP-BUCKET>
            retentionPeriodDays: 30
      image: europe-north1-docker.pkg.dev/[mgmt-id]/[team-name]/[image-name]:tag
      resources:
        limits:
          cpu: 200m
          memory: 128Mi
        requests:
          cpu: 100m
          memory: 64Mi
      restartPolicy: Never
      schedule: '0 */6 * * *'
      skipCaBundle: true
      successfulJobsHistoryLimit: 2
      ttlSecondsAfterFinished: 60
    ```

## 2. Create a network policy

???+ note ".nais/networkingpolicy.yaml"
   
    ```yaml 
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
      labels:
        app: <MY-BACKUP>
        team: <MY-TEAM>
      name: <MY-BACKUP-APISERVER>
      namespace: <MY-TEAM>
    spec:
      egress:
      - to:
        - ipBlock:
            cidr: 172.16.0.2/32
      podSelector:
        matchLabels:
          app: <MY-BACKUP>
      policyTypes:
      - Egress
    ```

## 3. Create RBAC resources

???+ note ".nais/rolebinding.yaml"
    
    ```yaml 
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: <MY-BACKUP>
      namespace: <MY-TEAM>
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: Role
      name: <MY-BACKUP>
    subjects:
    - namespace: <MY-TEAM>
      kind: ServiceAccount
    ```