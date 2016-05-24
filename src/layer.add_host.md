## Add Host [/api/layers/{id}/hosts{?hostid}]

### Add a host to a layer [POST]

Adds a new host to an existing layer. The host will assume all privileges of the layer.

This operation is idempotent: if the host is already in the layer, adding it again will do nothing.

Both `id` and `hostid` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

**Permission required**: You must have the layer role with `admin` option. This is the same
privilege required to grant the layer role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)


**Response**

|Code|Description|
|----|-----------|
|201|Host added to the layer|
|403|Permission denied|
|404|Existing layer or host not found|

+ Parameters
    + id: redis (string) - ID of the layer, query-escaped
    + hostid: cucumber:host:redis001 (string) - Fully qualified ID of the host to add, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json)

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
