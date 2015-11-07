## List Members [/api/authz/{account}/roles/group/{id}?members]

### List a group's members [GET]

Lists the direct members of a group.

Group IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|List of group members returned|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + account: conjur (string) - Organization account name
    + id: ops (string) - Name of the group, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:group:security_admin",
        "member": "conjur:user:admin",
        "role": "conjur:group:security_admin"
      },
      {
        "admin_option": true,
        "grantor": "conjur:user:admin",
        "member": "conjur:user:dustin",
        "role": "conjur:group:security_admin"
      },
      {
        "admin_option": false,
        "grantor": "conjur:user:dustin",
        "member": "conjur:user:bob",
        "role": "conjur:group:security_admin"
      }
    ]
    ```
