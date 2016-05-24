## List/Search [/api/authz/{account}/resources/host{?search,limit,offset,acting_as}]

### List or search for hosts [GET]

Lists all hosts the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the hosts with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of hosts is returned|
|403|Permission denied|

+ Parameters
    + account: cucumber (string) - organization account name
    + search: redis (string, optional) - Query for search
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as: cucumber:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:host:redis001",
        "owner": "cucumber:group:ops",
        "permissions": [
          {
            "privilege": "read",
            "grant_option": false,
            "resource": "cucumber:host:redis001",
            "role": "cucumber:host:redis001",
            "grantor": "cucumber:user:admin"
          }
        ],
        "annotations": []
      }
    ]
    ```
