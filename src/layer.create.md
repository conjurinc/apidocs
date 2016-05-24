## Create [/api/layers/{?id,ownerid}]

### Create a new layer [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the layer.
This means that no one else will be able to see your layer.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the layer|no|`String`|"jenkins/slaves"|
|ownerid|Fully qualified ID of a Conjur role that will own the new layer|no|`String`|"cucumber:group:ops"|

**Response**

|Code|Description|
|----|-----------|
|201|Layer created successfully|
|403|Permission denied|
|409|A layer with that name already exists|

+ Parameters
    + id: redis (string, optional) - Name of the layer, query-escaped
    + ownerid: cucumber:group:ops (string, optional) - Fully qualified ID of a Conjur role that will own the new layer

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json)

    ```
    {
      "id": "redis",
      "userid": "admin",
      "ownerid": "cucumber:group:ops",
      "roleid": "cucumber:layer:redis",
      "resource_identifier": "cucumber:layer:redis",
      "hosts": []
    }
    ```
