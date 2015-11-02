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
    + account: demo (string) - Organization account name
    + id: tech%2Fops (string) - Name of the group, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "admin_option": true,
        "grantor": "demo:group:security_admin",
        "member": "demo:user:admin",
        "role": "demo:group:security_admin"
      },
      {
        "admin_option": true,
        "grantor": "demo:user:admin",
        "member": "demo:user:dustin",
        "role": "demo:group:security_admin"
      },
      {
        "admin_option": false,
        "grantor": "demo:user:dustin",
        "member": "demo:user:bob",
        "role": "demo:group:security_admin"
      }
    ]
    ```
