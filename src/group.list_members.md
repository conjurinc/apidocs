## List Members [/api/authz/{account}/roles/group/{id}?members]

### List a group's members [GET]

Lists the direct members of a group.

Group IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: You must be a member of the group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|List of group members returned|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + account: cucumber (string) - Organization account name
    + id: ops (string) - Name of the group, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "admin_option": true,
        "grantor": "cucumber:group:security_admin",
        "member": "cucumber:user:admin",
        "role": "cucumber:group:security_admin"
      },
      {
        "admin_option": true,
        "grantor": "cucumber:user:admin",
        "member": "cucumber:user:dustin",
        "role": "cucumber:group:security_admin"
      },
      {
        "admin_option": false,
        "grantor": "cucumber:user:dustin",
        "member": "cucumber:user:bob",
        "role": "cucumber:group:security_admin"
      }
    ]
    ```
