## List Layers [/api/authz/{account}/roles/host/{id}/?all]

### List the layers to which a host belongs [GET]

A host may belong to multiple layers at once.

Host IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|List of layers is returned|
|403|Permission denied|
|404|Host not found|

+ Parameters
    + account: demo (string) - Organization account name
    + id: slave01 (string) - Name of the host, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
        "jenkins/slaves"
    ]
    ```
