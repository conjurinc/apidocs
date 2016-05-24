## List Annotations [/api/authz/{account}/resources/{kind}/{id}]

### List the annotations on a resource [GET]

There is no specific route for listing annotations, but the record of a resource
lists all annotations when you retrieve it. You can then parse the JSON to get the annotations list.

**Permission required**: `read` privilege on the resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Resource metadata is returned|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: redis (string) - ID of the resource to show

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
        "id":"cucumber:layer:redis",
        "owner":"cucumber:group:security_admin",
        "permissions":[
            {
                "privilege":"read",
                "grant_option":false,
                "resource":"cucumber:layer:redis",
                "role":"conjur:@:layer/redis/observe",
                "grantor":"cucumber:user:admin"
            }
        ],
        "annotations":[
            {
                "resource_id":18,
                "name":"aws:account",
                "value":"ci",
                "created_at":"2015-11-07T16:51:50.446+00:00",
                "updated_at":"2015-11-07T16:53:37.524+00:00"
            }
        ]
    }
    ```
