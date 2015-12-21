## Single [/api/audit/{kind}/{id}]

### Fetch audit events for a single role/resource [GET]

Fetch audit events for a role/resource the calling identity has `read` privilege on.

`id` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|403|Permission denied|
|404|Role/resource not found|

+ Parameters
    + kind: roles (string) - Type of object, 'roles' or 'resources'
    + id: cucumber:host:redis001 (string) - Fully qualified ID of a Conjur role/resource, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept: */*
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "resources": [],
        "roles": [
          "cucumber:user:admin",
          "cucumber:group:ops",
          "cucumber:host:redis001"
        ],
        "action": "create",
        "role_id": "cucumber:host:redis001",
        "creator": "cucumber:group:ops",
        "role": "cucumber:host:redis001",
        "timestamp": "2015-11-07T04:41:22.406Z",
        "event_id": "a06f5f34da97a544abdd1a38cd337829",
        "id": 57,
        "user": "cucumber:user:admin",
        "acting_as": "cucumber:group:ops",
        "request": {
          "ip": "127.0.0.1",
          "url": "http://localhost:5100/cucumber/roles/host/redis001",
          "method": "PUT",
          "params": {
            "acting_as": "cucumber:group:ops",
            "controller": "roles",
            "action": "create",
            "account": "conjur",
            "role": "host/redis001"
          },
          "uuid": "300422d8-342a-416c-a597-8bb698b0361a"
        },
        "conjur": {
          "domain": "authz",
          "env": "appliance",
          "user": "cucumber:user:admin",
          "role": "cucumber:group:ops",
          "account": "conjur"
        },
        "kind": "role"
      }
    ]
    ```
