## All [/api/audit]

### Fetch all audit events [GET]

Fetch audit events for all roles and resources the calling identity has `read` privilege on.

The example shows a single audit event returned.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|403|Permission denied|

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept: */*
        ```

+ Response 200 (application/json)

    ```
    [
      {
        "resources":[
    
        ],
        "roles":[
          "cucumber:user:admin"
        ],
        "action":"all_roles",
        "role":"cucumber:user:admin",
        "filter":[
          "cucumber:group:security_admin"
        ],
        "allowed":true,
        "timestamp":"2015-11-07T17:24:21.085Z",
        "event_id":"4af71f3bf6648b299c59c4ffc8a142db",
        "id":1122,
        "user":"cucumber:user:admin",
        "acting_as":"cucumber:user:admin",
        "request":{
          "ip":"127.0.0.1",
          "url":"http://localhost:5100/cucumber/roles/user/admin?all\u0026filter%5B%5D=conjur%3Agroup%3Asecurity_admin",
          "method":"GET",
          "params":{
            "all":null,
            "filter":[
              "cucumber:group:security_admin"
            ],
            "controller":"roles",
            "action":"all_roles",
            "account":"conjur",
            "role":"user/admin"
          },
          "uuid":"b0ced92e-9a1c-461b-aa51-b04211f7d307"
        },
        "conjur":{
          "domain":"authz",
          "env":"appliance",
          "user":"cucumber:user:admin",
          "role":"cucumber:user:admin",
          "account":"conjur"
        },
        "kind":"role"
      },
      {
        "resources":[
          "cucumber:user:alice"
        ],
        "roles":[
          "cucumber:user:admin"
        ],
        "resource":"cucumber:user:alice",
        "action":"check",
        "privilege":"update",
        "allowed":true,
        "timestamp":"2015-11-07T17:24:21.118Z",
        "event_id":"ec72aa9c08f005d6c8598ad055594d88",
        "id":1123,
        "user":"cucumber:user:admin",
        "acting_as":"cucumber:user:admin",
        "request":{
          "ip":"127.0.0.1",
          "url":"http://localhost:5100/cucumber/resources/user/alice?check=true\u0026privilege=update",
          "method":"GET",
          "params":{
            "check":"true",
            "privilege":"update",
            "controller":"resources",
            "action":"check_permission",
            "account":"conjur",
            "kind":"user",
            "identifier":"alice"
          },
          "uuid":"aef23372-2933-4aa1-9597-99b7bbcfe22b"
        },
        "conjur":{
          "domain":"authz",
          "env":"appliance",
          "user":"cucumber:user:admin",
          "role":"cucumber:user:admin",
          "account":"conjur"
        },
        "kind":"resource"
      }
    ]
    ```
