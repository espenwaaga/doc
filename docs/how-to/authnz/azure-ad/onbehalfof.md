# OAuth 2.0 On-Behalf-Of Grant
This guide shows you how to use the OAuth 2.0 On-Behalf-Of grant to consume downstream APIs from your application.

## 0. Prerequisites

1. Your application (also known as a [resource server](../../../explanation/authnz/concepts/actors.md#resource-server)) and the downstream API that you want to consume both have [enabled Azure AD](enable.md).
2. Your application has been [granted access](access-application.md) to the downstream API.


## 1. Validate subject token
[Validate the subject token](./validate-token.md) from the incoming request.

## 2. Request a new token
Request a new token that is scoped to the downstream API.
Set the `scope` parameter to `api://<DOWNSTREM-ENV>.<OTHER-TEAM>.<OTHER-APP>/.default`

- Request:
```http hl_lines="8"
POST ${AZURE_OPENID_CONFIG_TOKEN_ENDPOINT} HTTP/1.1
Content-Type: application/x-www-form-urlencoded

grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer
&client_id=${AZURE_APP_CLIENT_ID}
&client_secret=${AZURE_APP_CLIENT_SECRET}
&assertion=<subject_token>
&scope=api://<DOWNSTREAM-ENV>.<OTHER-TEAM>.<OTHER-APP>/.default
&requested_token_use=on_behalf_of
```

- Response (token omitted for brevity):
```json
{
  "access_token" : "eyJ0eX[...]",
  "expires_in" : 3599,
  "token_type" : "Bearer"
}
```

!!! tip "Token Caching"
    The `expires_in` field denotes the lifetime of the token in seconds.
    **Cache and reuse the token until it expires** to minimize network latency impact.
    A safe cache key for on-behalf-of tokens is `key = sha256($subject_token + $scope)`.
    - The new token has an audience equal to the downstream API. Your application does not need to validate this token.

## 3. Consume the downstream API
Consume the downstream API by using the new token as a [Bearer token](../../../explanation/authnz/concepts/tokens.md#bearer-token). 