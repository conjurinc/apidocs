## Show [/api/variables/{id}]

### Retrieve a variable's record [GET]

This route returns information about a variable, but **not** the
variable's value. Use the [variable#value](#reference/variable/value)
route to retrieve variable values.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**:

`read` privilege on the variable.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Variable metadata is returned|
|403|Permission denied|
|404|Variable not found|

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable, query-escaped

+ Request (application/json; charset=utf-8)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "admin",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "conjur:user:admin",
        "resource_identifier": "conjur:variable:dev/mongo/password",
        "version_count": 1
    }
    ```
