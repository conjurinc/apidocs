## Create [/api/layers/]

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
|ownerid|Fully qualified ID of a Conjur role that will own the new layer|no|`String`|"demo:group:ops"|

**Response**

|Code|Description|
|----|-----------|
|201|Layer created successfully|
|403|Permission denied|
|409|A layer with that name already exists|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {
            "id": "jenkins/slaves",
            "ownerid": "demo:group:ops",
        }
        ```

+ Response 201 (application/json)

    ```
    {
      "id": "jenkins/slaves",
      "userid": "demo",
      "ownerid": "demo:group:ops",
      "roleid": "demo:layer:jenkins/slaves",
      "resource_identifier": "demo:layer:jenkins/slaves",
      "hosts": []
    }
    ```
