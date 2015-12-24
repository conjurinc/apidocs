### Revoke a granted role [DELETE]

Inverse of `role#grant_to`.

**Permission Required**: `admin_option` on the role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Role revoked|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: cucumber (string) - organization account name
    + role: group/ops (string) - ID of the role to grant
    + member: user:bob (string) - ID of the member role being revoked

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
