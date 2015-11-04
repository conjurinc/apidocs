## Single [/api/audit/{kind}/{id}{?limit,offset}]

### Fetch audit events for a single role/resource [GET]

Fetch audit events for a role/resource the calling identity has `read` privilege on.

You can limit and offset the resulting list of events.

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
    + id: demo%3Ahost%3Aredis001 (string) - Fully qualified ID of a Conjur role/resource, query-escaped
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
            "demo:group:security_admin",
            "demo:host:redis001"
          ],
          "action": "create",
          "role_id": "demo:host:redis001",
          "creator": "demo:group:security_admin",
          "role": "demo:host:redis001",
          "timestamp": "2015-11-03T21:33:17.974Z",
          "event_id": "c5e9788790c51fb334d9517fdd603ce4",
          "id": 183,
          "user": "demo:user:lisa",
          "acting_as": "demo:group:security_admin",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/roles/host/redis001",
            "method": "PUT",
            "params": {
              "acting_as": "demo:group:security_admin",
              "controller": "roles",
              "action": "create",
              "account": "demo",
              "role": "host/redis001"
            },
            "uuid": "a432a32e-875e-489f-8f18-6aa3ef6df0cc"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:group:security_admin",
            "account": "demo"
          },
          "kind": "role"
        },
        {
          "resources": [
            "demo:host:redis001"
          ],
          "roles": [
            "demo:user:lisa",
            "demo:host:redis001"
          ],
          "resource": "demo:host:redis001",
          "action": "permit",
          "privilege": "read",
          "grantee": "demo:host:redis001",
          "grantor": "demo:user:lisa",
          "timestamp": "2015-11-03T21:33:18.012Z",
          "event_id": "8faec6a55a4e299abd737af9e0187d3e",
          "id": 185,
          "user": "demo:user:lisa",
          "acting_as": "demo:user:lisa",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/resources/host/redis001?permit&privilege=read&role=demo:host:redis001",
            "method": "POST",
            "params": {
              "permit": null,
              "privilege": "read",
              "role": "demo:host:redis001",
              "controller": "resources",
              "action": "grant_permission",
              "account": "demo",
              "kind": "host",
              "identifier": "redis001"
            },
            "uuid": "3c50d04a-0f34-420b-8027-f9e4df3b882a"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:user:lisa",
            "account": "demo"
          },
          "kind": "resource"
        }
        ... // more events
    ]
    ```
