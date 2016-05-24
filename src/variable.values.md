## Values [/api/variables/values{?vars}]

### Retrieve the values of multiple variables at once [GET]

If you need to retrieve the values of multiple variables at once, this route is much more
efficient than [variable#value](/#reference/variable/value).


Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission Required**: `execute` privilege on all variables to be retrieved.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON map of variables names to values is returned|
|403|Permission denied|
|404|One or more of the variables was not found|

+ Parameters
    + vars: dev/mongo/password,dev/redis/password (string) - Comma-separated list of variable IDs to fetch, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "dev/mongo/password": "np89daed89p",
      "dev/redis/password": "8912dbp9bu1pub"
    }
    ```

+ Response 404 (application/json)

    ```
    {
      "error": {
        "kind": "RecordNotFound",
        "message": "variable 'staging/mongo/password' not found",
        "details": {
          "kind": "variable",
          "id": "staging/mongo/password"
        }
      }
    }
    ```
