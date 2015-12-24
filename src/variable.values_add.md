## Values Add [/api/variables/{id}/values]

### Add a value to a variable [POST]

Variable ids must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission Required**: `update` privilege on the variable.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|value|New value to set for the variable|yes|`String`|"np89daed89p"|

**Response**

|Code|Description|
|----|-----------|
|201|Value added|
|403|Permission denied|
|404|Variable not found|
|422|Value malformed or missing|

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {
            "value": "np89daed89p"
        }
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id":"dev/mongo/password",
        "userid":"admin",
        "mime_type":"text/plain",
        "kind":"secret",
        "ownerid":"cucumber:user:admin",
        "resource_identifier":"cucumber:variable:dev/mongo/password",
        "version_count":1
    }
    ```
