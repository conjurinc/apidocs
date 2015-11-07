## List members [/api/authz/{account}/roles/{kind}/{id}?members]

### Lists the roles that have been the recipient of a role grant [GET]

The creator of the role is always a role member and role administrator.

If role "A" is created by user "U" and then granted to roles "B" and "C",
then the members of role "A" are [ "U", "B", "C" ].

Role members are not expanded transitively.
Only roles which have been explicitly granted the role in question are listed.

**Permission Required**: Admin option on the role

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Role memberships returned as JSON list|
|404|Role does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: ops (string) - ID of the role

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:group:ops",
        "member": "conjur:group:security_admin",
        "role": "conjur:group:ops"
      }
    ]
    ```