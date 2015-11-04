## All [/api/audit{?limit,offset}]

### Fetch all audit events [GET]

Fetch audit events for all roles and resources the calling identity has `read` privilege on.

You can limit and offset the resulting list of events.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|403|Permission denied|

+ Parameters
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept-Encoding: gzip, deflate
        ```

+ Response 200 (application/json)

    ```
    [
        {
          "resources": [],
          "roles": [
            "demo:user:lisa",
            "demo:@:layer/jenkins/slaves/observe",
            "demo:@:layer/jenkins/slaves/use_host"
          ],
          "action": "grant",
          "role": "demo:@:layer/jenkins/slaves/observe",
          "member": "demo:@:layer/jenkins/slaves/use_host",
          "grantor": "demo:user:lisa",
          "timestamp": "2015-11-03T20:11:47.789Z",
          "event_id": "8bf37b524d95df2ab4c1fe7e3f89267d",
          "id": 96,
          "user": "demo:user:lisa",
          "acting_as": "demo:user:lisa",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/roles/@/layer/jenkins/slaves/observe?members&member=demo:@:layer/jenkins/slaves/use_host",
            "method": "PUT",
            "params": {
              "members": null,
              "member": "demo:@:layer/jenkins/slaves/use_host",
              "controller": "roles",
              "action": "update_member",
              "account": "demo",
              "role": "@/layer/jenkins/slaves/observe",
              "admin_option": null
            },
            "uuid": "3f0a0cfe-eef1-4a6d-a4a5-a0ebc1f20fc6"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:user:lisa",
            "account": "demo"
          },
          "kind": "role"
        }
        ... // more events
    ]
    ```
