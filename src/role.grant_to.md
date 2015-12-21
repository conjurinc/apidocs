## Grant to / Revoke from [/api/authz/{account}/roles/{role}/?members&member={member}&admin_option={admin_option}]

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
    + account: cucumber (string) - organization account name
    + role: group/ops (string) - ID of the role to grant
    + member: user:charles (string) - Id of the new member role
    + admin_option: false (boolean) - Whether the member will be allowed to add/remove members of the role

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {admin_option: true}
        ```

+ Response 200
