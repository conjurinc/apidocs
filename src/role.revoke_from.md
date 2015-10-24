### Revoke a granted role [DELETE]

Inverse of `role#grant_to`.

**Permission Required**: Admin option on the role


+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Response 200 (text/plain)

    ```
    Role revoked
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Role does not exist
    ```
