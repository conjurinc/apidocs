## Show [/api/layers/{id}]

### Retrieve a layer's metadata [GET]

This route returns information about a layer, including its attached hosts.

Layer IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the layer.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Layer metadata is returned|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + id: jenkins%2Fslaves (string) - Name of the layer, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
        "id": "jenkins/slaves",
        "userid": "demo",
        "ownerid": "demo:group:ops",
        "roleid": "demo:layer:jenkins/slaves",
        "resource_identifier": "demo:layer:jenkins/slaves",
        "hosts": [
            "demo:host:slave01"
        ]
    }
    ```
