## Show [/api/hosts/{id}]

### Retrieve a host's metadata [GET]

This route returns information about a host.
The host's API key is not returned in this response.

Host IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Host metadata is returned|
|403|Permission denied|
|404|Host not found|

+ Parameters
    + id: redis001 (string) - Name of the host, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "id": "redis001",
      "userid": "admin",
      "created_at": "2015-11-03T21:33:17Z",
      "ownerid": "cucumber:group:ops",
      "roleid": "cucumber:host:redis001",
      "resource_identifier": "cucumber:host:redis001"
    }
    ```
