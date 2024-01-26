# Fine-Grained Group-Based Access Control

If you need more fine-grained access controls, you will need to handle authorization in your application by using the `groups` claim found in the user's [JWT](../../../explanation/authnz/concepts/tokens.md#jwt).

The `groups` claim in user tokens contains a list of [group object IDs](../../../explanation/authnz/azure/README.md#group-identifier) if and only if:

1. The group is explicitly assigned to the application, and
2. The user is a _direct_ member of the group

Because no groups are assigned to the application by default, the claim is also omitted by default.


This configuration only affects tokens that are acquired where your application is the intended audience (i.e. [scoped](README.md#scopes) to your application).

All user tokens acquired for your application will now include the `groups` claim.

??? example "Example decoded on-behalf-of token (click to expand)"

    ```json hl_lines="10-12"
    {
        "aud": "8a5...",
        "iss": "https://login.microsoftonline.com/.../v2.0",
        "iat": 1624957183,
        "nbf": 1624957183,
        "exp": 1624961081,
        "aio": "AXQ...",
        "azp": "e37...",
        "azpacr": "1",
        "groups": [
            "2d7..."
        ],
        "name": "Navnesen, Navn",
        "oid": "15c...",
        "preferred_username": "Navn.Navnesen@nav.no",
        "rh": "0.AS...",
        "scp": "defaultaccess",
        "sub": "6OC...",
        "tid": "623...",
        "uti": "i03...",
        "ver": "2.0"
    }
    ```

Your application can then use this claim to implement custom user authorization logic.