# Token Validation
This guide will show you how to validate tokens from incoming requests

## 1. Verify incoming requests
Verify incoming requests by validating the [Bearer token](../../../explanation/authnz/concepts/tokens.md#bearer-token) in the `Authorization` header.

Always validate the [signature and standard time-related claims](../../../explanation/authnz/concepts/tokens.md#token-validation).

## 2. Validate issuer
Validate that the `iss` claim has a value that is equal to either:

1. the `AZURE_OPENID_CONFIG_ISSUER` [environment variable](#variables-for-validating-tokens), or 
2. the `issuer` property from the [metadata discovery document](../../../explanation/authnz/concepts/actors.md#well-known-url-metadata-document).
    The document is found at the endpoint pointed to by the `AZURE_APP_WELL_KNOWN_URL` environment variable.

## 3. Validate audience
Validate that the `aud` claim is equal to the `AZURE_APP_CLIENT_ID` environment variable.

## 4. Validate signature
Validate that the token is signed with a public key published at the JWKS endpoint.
This endpoint URI can be found in one of two ways:

1. the `AZURE_OPENID_CONFIG_JWKS_URI` environment variable, or
2. the `jwks_uri` property in the metadata discovery document.
   The document is found at the endpoint pointed to by the `AZURE_APP_WELL_KNOWN_URL` environment variable.

## 5. Validate Other Token Claims
Other claims may be present in the token.
Validation of these claims is optional.

Notable claims:

- `azp` (**authorized party**)
    - The [client ID](../../../explanation/authnz/concepts/actors.md#client-id) of the application that requested the token (this would be your consumer).
- `azp_name` (**authorized party name**)
    - The value of this claim is the (human-readable) [name](../../../explanation/authnz/azure/README.md#client-name) of the consumer application that requested the token.
- `groups` (**groups**)
    - JSON array of object IDs for [Azure AD groups](../../../explanation/authnz/azure/README.md#groups).
    - This claim only applies in flows where a user is involved i.e., either the [sign-in](../../../explanation/authnz/azure/README.md#openid-connect-authorization-code-flow) or [on-behalf-of](./onbehalfof.md) flows.
    - In order for a group to appear in the claim, all the following conditions must be true:
        - The given user is a direct member of the group.
        - The group is [assigned to the client](./access-user.md#1-add-permitted-audience).
- `idtyp` (**identity type**)
    - This is a special claim used to determine whether a token is a [machine-to-machine](../../../explanation/authnz/azure/README.md#application-authentication) (app-only) token or a user/[on-behalf-of](../../../explanation/authnz/azure/README.md#oauth-20-on-behalf-of-grant) token.
    - The claim currently only appears in machine-to-machine tokens. The value is `app` when the token is a machine-to-machine token.
    - In short: if the `idtyp` claim exists and it has the value `app`, then it is a machine-to-machine token. Otherwise, it is a user/on-behalf-of token.
- `NAVident` (**NAV ident**)
    - The value of this claim maps to an internal identifier for the employees in NAV.
    - This claim thus only applies in flows where a user is involved i.e., either the [sign-in](../../../explanation/authnz/azure/README.md#openid-connect-authorization-code-flow) or [on-behalf-of](../../../explanation/authnz/azure/README.md#oauth-20-on-behalf-of-grant) flows.
- `roles` (**roles**)
    - The value of this claim is an _array of strings_ that lists the roles that the application has access to:
    ```json
    {
      "roles": [
        "access_as_application",
        "role-a",
        "role-b"
      ]
    }
    ```
    - This claim **only** applies to [machine-to-machine](../../../explanation/authnz/azure/README.md#oauth-20-client-credentials-grant) tokens.
    - Consumers defined in the [access policy](configuration.md#applications) are always assigned the default role named `access_as_application`.
    - You can optionally define and grant additional [custom roles](configuration.md#custom-roles) to consumers.
- `scp` (**scope**)
    - The value of this claim is a _space-separated string_ that lists the scopes that the application has access to:
    ```json
    {
       "scp": "defaultaccess scope1 scope2"
    }
    ```
    - This claim **only** applies to user or [on-behalf-of](#oauth-20-on-behalf-of-grant) tokens.
    - Consumers defined in the [access policy](configuration.md#applications) are always assigned the default scope named `defaultaccess`.
    - You can optionally define and grant additional [custom scopes](configuration.md#custom-scopes) to consumers.

For a complete list of claims, see the [Access Token Claims Reference in Azure AD](https://learn.microsoft.com/en-us/azure/active-directory/develop/access-token-claims-reference).
Tokens in NAV are v2.0 tokens.

#### Variables for Validating Tokens

These variables are used for token validation:

| Name                           | Description                                                                                                       |
|:-------------------------------|:------------------------------------------------------------------------------------------------------------------|
| `AZURE_APP_CLIENT_ID`          | [Client ID](../concepts/actors.md#client-id) that uniquely identifies the application in Azure AD.                |
| `AZURE_OPENID_CONFIG_ISSUER`   | `issuer` from the [metadata discovery document](../concepts/actors.md#issuer).                                    |
| `AZURE_OPENID_CONFIG_JWKS_URI` | `jwks_uri` from the [metadata discovery document](../concepts/actors.md#jwks-endpoint-public-keys).               |
| `AZURE_APP_WELL_KNOWN_URL`     | The well-known URL for the [metadata discovery document](../concepts/actors.md#well-known-url-metadata-document). |

`AZURE_APP_WELL_KNOWN_URL` is optional if you're using `AZURE_OPENID_CONFIG_ISSUER` and `AZURE_OPENID_CONFIG_JWKS_URI` directly.