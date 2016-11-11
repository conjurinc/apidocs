## Create [/api/variables]

:[deprecation_warning_4.8](partials/deprecation_warning_4.8.md)

### Create a new variable [POST]

A variable can be created with or without an initial value.
If you don't give the variable an ID, one will be randomly generated.

Note that you can give the variable an initial value, but this is optional.
Use the [Variable > Values Add](http://docs.conjur.apiary.io/#reference/variable/values-add) 
route to set values for variables.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the variable|no|`String`|"dev/mongo/password"|
|ownerid|Fully qualified ID of a Conjur role that will own the new variable|no|`String`|"cucumber:group:developers"|
|mime_type|Media type of the variable|yes|`String`|"text/plain"|
|kind|Purpose of the variable|no|`String`|"password"|
|value|Value of the variable|no|`String`|"p89b12ep12puib"|

**Response**

|Code|Description|
|----|-----------|
|201|Variable created successfully|
|403|Permission denied|
|409|A variable with that name already exists|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {
            "id": "dev/mongo/password",
            "kind": "password",
            "mime_type": "text/plain",
            "value": "p89b12ep12puib",
            "ownerid": "cucumber:group:security_admin"
        }
        ```

+ Response 201 (application/json)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "alice",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "cucumber:group:security_admin",
        "resource_identifier": "cucumber:variable:dev/mongo/password",
        "version_count": 1
    }
    ```
