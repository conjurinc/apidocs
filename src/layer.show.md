## Show [/api/layers/{id}]

### Retrieve a layer's record [GET]

This route returns information about a layer, including its attached hosts.

Layer IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the layer.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Layer record is returned|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + id: redis (string) - Name of the layer, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "id": "redis",
      "userid": "admin",
      "ownerid": "cucumber:group:ops",
      "roleid": "cucumber:layer:redis",
      "resource_identifier": "cucumber:layer:redis",
      "hosts": [
        "cucumber:host:redis001"
      ]
    }
    ```
