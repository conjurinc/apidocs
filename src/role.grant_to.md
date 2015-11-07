## Grant to / Revoke from [/api/authz/{account}/roles/{role_a}/?members&member={role_b}]

### Grant a role to another role [PUT]

All of this role's privileges are thereby granted to the new role.

When granted with `admin_option`, the grantee (given-to) role can grant the grantor (given-by) role to others.

`admin_option` is passed in the request body.

**Permission Required**: Admin option on the role

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|admin_option|Allow grantee admin rights|no|`Boolean`|true|

**Response**

|Code|Description|
|----|-----------|
|200|Role granted|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + role_a: user/alice (string) - ID of the owner role `{kind}/{id}`, query-escaped
    + role_b: group:ops (string) - Qualified ID of the role we're granting membership to

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {admin_option: true}
        ```

+ Response 200
