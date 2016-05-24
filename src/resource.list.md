## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists all resources the calling identity has `read` privilege on.

Run a full-text search of the resources with the `search` parameter.

You can also limit, offset and shorten the resulting list.

**Permission Required**

The result only includes resources on which the current role has some privilege.
In other words, resources on which you have no privilege are invisible to you.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of visible resources|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable_group (string) - kind of the resource, for example 'variable' or 'host'
    + search: aws_keys (string, optional) - search string
    + limit (string, optional) - limits the number of response records
    + offset (string, optional) - offset into the first response record

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:variable_group:aws_keys",
        "owner": "cucumber:group:ops",
        "permissions": [],
        "annotations": []
      }
    ]
    ```
