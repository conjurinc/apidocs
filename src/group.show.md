## Show [/api/groups/{id}]

### Retrieve a group's metadata [GET]

Returns information about a group.

Group IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Group metadata is returned|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + id: tech%2Fops (string) - Name of the group, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
        "id":"tech/ops",
        "userid":"demo",
        "ownerid":"demo:group:security_admin",
        "gidnumber":null,
        "roleid":"demo:group:tech/ops",
        "resource_identifier":"demo:group:tech/ops"
    }
    ```
