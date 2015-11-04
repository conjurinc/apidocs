## Show [/api/authz/{account}/annotations/{kind}/{id}/]

### Retrieve a resources's record [GET]

Retrieves a resource's metadata, including annotations.

**Permission Required**

`read` permission on the resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|The response body contains the resource's record|
|403|You don't have permission to view the record|
|404|No record exists with the given ID|

+ Parameters
    + account: demo (string) - organization account name
    + kind: chatbot (string) - kind of the resource, for example 'variable' or 'host'
    + id: hubot (string) - ID of the resource to show

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "id": "demo:chatbot:hubot",
      "owner": "demo:group:ops",
      "permissions": [
    
      ],
      "annotations": [
          {
            "resource_id": 36,
            "name": "client",
            "value": "slack",
            "created_at": "2015-11-04T21:06:14.208+00:00",
            "updated_at": "2015-11-04T21:06:14.208+00:00"
          }
      ]
    }
    ```
