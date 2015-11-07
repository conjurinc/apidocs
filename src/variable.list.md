## List/Search [/api/authz/{account}/resources/variable{?search,limit,offset,acting_as}]

### List or search for variables [GET]

Lists all variables the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the variables with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of variables is returned|
|403|Permission denied|

+ Parameters
    + account: demo (string) - organization account name
    + search: mongo (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:variable:dev/mongo/password",
        "owner": "conjur:user:admin",
        "permissions": [
    
        ],
        "annotations": [
        ]
      }
    ]
    ```
