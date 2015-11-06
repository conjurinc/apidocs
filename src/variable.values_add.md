## Values Add [/api/variables/{id}/values]

### Add a value to a variable [POST]

Variable ids must be escaped in the url, e.g., `'/' -> '%2F'`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

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
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

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
        "ownerid":"conjur:user:admin",
        "resource_identifier":"conjur:variable:dev/mongo/password",
        "version_count":1
    }
    ```
