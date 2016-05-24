## List/Search [/api/authz/{account}/resources/host_factory{?search,limit,offset,acting_as}]

### List or search for host factories [GET]

Lists all host factories the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the host factories with the `search` parameter.

You can also limit and offset the resulting list.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of host factories is returned|
|403|Permission denied|

+ Parameters
    + account: cucumber (string) - organization account name
    + search: redis (string, optional) - Query for search
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:host_factory:redis_factory",
        "owner": "cucumber:group:security_admin",
        "permissions": [],
        "annotations": []
      }
    ]
    ```
