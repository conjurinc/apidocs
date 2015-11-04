## List Annotations [/api/authz/{account}/annotations/{kind}/{id}]

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
    + account: demo (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: jenkins/slaves (string) - ID of the resource to show

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "id": "demo:layer:jenkins/slaves",
      "owner": "demo:group:security_admin",
      "permissions": [
        {
          "privilege": "read",
          "grant_option": false,
          "resource": "demo:layer:jenkins/slaves",
          "role": "demo:@:layer/jenkins/slaves/observe",
          "grantor": "demo:user:terry"
        }
      ],
      "annotations": [
        {
          "resource_id": 25,
          "name": "aws/account",
          "value": "ci",
          "created_at": "2015-11-04T20:51:19.716+00:00",
          "updated_at": "2015-11-04T20:51:19.716+00:00"
        }
      ]
    }
    ```
