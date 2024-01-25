# OAuth 2.0 Client Credentials Grant


## 0. Prerequisites

1. Your application (also known as a [resource server](../../../explanation/authnz/concepts/actors.md#resource-server)) and the downstream API that you want to consume both have [enabled Azure AD](./enable.md).
2. Your application has been [granted access](./access-application.md) to the downstream API.

## 1. Request token
Request a new token that is scoped to the downstream API.
 - Set the `scope` parameter to `api://<MY-ENV>.<MY-TEAM>.<OTHER-APP>/.default`
 - Request:
    ```http
    POST ${AZURE_OPENID_CONFIG_TOKEN_ENDPOINT} HTTP/1.1
    Content-Type: application/x-www-form-urlencoded

    client_id=${AZURE_APP_CLIENT_ID}
    &client_secret=${AZURE_APP_CLIENT_SECRET}
    &scope=api://<cluster>.<namespace>.<outbound-app-name>/.default
    &grant_type=client_credentials
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
     
         A safe cache key for client credentials tokens is `key = $scope`.

 - The new token has an audience equal to the downstream API. Your application does not need to validate this token.

2. Consume downstream API by using the token as a [Bearer token](../concepts/tokens.md#bearer-token). The downstream API [validates the token](#token-validation) and returns a response.
3. Repeat step 1 and 2 for each unique API that your application consumes.
4. The downstream API(s) may continue the call chain by starting from step 1.

For further details, see [Microsoft identity platform and the OAuth 2.0 client credentials flow](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow).
