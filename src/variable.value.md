## Value [/api/variables/{id}/value?{version}]

### Retrieve the value of a variable [GET]

By default this returns the latest version of a variable, but you can retrieve any earlier version as well.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Variable value is returned|
|403|Permission denied|
|404|Variable, or requested version of the value, not found|

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable, query-escaped
    + version (string, optional) - Version of the variable to retrieve

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (text/plain; charset=utf-8)

    ```
    np89daed89p
    ```
