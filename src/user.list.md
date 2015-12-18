## List/Search [/api/authz/{account}/resources/user{?search,limit,offset,acting_as}]

### List or search for users [GET]

Lists all users the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the users with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of users is returned|
|403|Permission denied|

+ Parameters
    + account: demo (string) - organization account name
    + search: kenneth (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "demo:user:alice",
        "owner": "cucumber:group:admin",
        "permissions": [
    
        ],
        "annotations": {
        }
      }
    ]
    ```
