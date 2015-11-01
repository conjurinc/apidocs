### Revoke a granted role [DELETE]

Inverse of `role#grant_to`.

**Permission Required**: Admin option on the role

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Role revoked|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (text/plain)

    ```
    Role revoked
    ```
