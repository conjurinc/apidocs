## List/Search [/api/authz/{account}/resources/group{?search,limit,offset,acting_as}]

### List or search for groups [GET]

Lists all groups the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the groups with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of groups is returned|
|403|Permission denied|

+ Parameters
    + account: cucumber (string) - organization account name
    + search: ops (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:group:ops",
        "owner": "cucumber:group:security_admin",
        "permissions": [
    
        ],
        "annotations": [
        ]
      }
    ]
    ```
