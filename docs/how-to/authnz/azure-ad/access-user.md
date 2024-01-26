# Grant access to users

This guide will show you how to grant users access to your application.

## 1. Add permitted audience
=== "All users"
    If you want to allow _all_ users in the Azure AD tenant to access your application, you must explicitly enable this:

    ```yaml hl_lines="5"
    spec:
    azure:
        application:
            enabled: true
            allowAllUsers: true
    ```

=== "Specific groups"

    In many cases, you want to only allow certain groups of users to have access to your application.

    The user must be a _direct_ member of the group.
    Nested groups are not supported, i.e. membership of a group within a group does not propagate to the parent group.

    ```yaml hl_lines="4-7"
    spec:
    azure:
        application:
            enabled: true
            allowAllUsers: false
            claims:
                groups:
                - id: "<object ID of group in Azure AD>"
    ```

If a user is not a _direct_ member of any of the configured groups, Azure AD will now return an error if the user attempts to sign in to your application.

Consumers using the [on-behalf-of flow](./onbehalfof.md) will also receive failures if the user is not a member of any of the configured groups.

You can also configure [more fine-grained access control](./access-fine-grained.md)

## 2. Apply the application
=== "Automatically"
    Add the file to your application repository to deploy with [NAIS github action](../../cicd/github-action.md).
=== "Manually"
    ```bash
    kubectl apply -f ./nais/app.yaml --namespace=<MY-TEAM> --context=<MY-CLUSTER>
    ```