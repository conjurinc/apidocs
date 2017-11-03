## Multiple Roles or Resources [/api/audit/events{?role[]*,resource[]*,event_action,kind,limit,till,since}]

### Fetch audit events matching any subset of roles or resources [GET]

Fetch audit events matching any of a set of roles and/or resources the calling identity has `read` privilege on.

If the calling identity does not have `read` privilege on *all* roles and resources
sent with the request, the API will return a `404 Not Found` response.


The `role` and `resource` ID-values must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|401|Unauthorized|
|403|Permission denied|
|404|Role/resource not found / permission denied|

+ Parameters
    + role: `cucumber:host:redis001` (string, optional) - One or more fully qualified IDs of a Conjur role, query-escaped
    + resource: `cucumber:group:sys_admins` (string, optional) - One or more fully qualified IDs of a Conjur resource, query escaped
    + event_action: `create` (string, optional) - Event action
    + kind: `role` (string, optional) - Object class impacted by event
    + limit: `10` (number, optional) - Maximum number of results to return
    + till: `2017-11-03T17:00:00.000Z` (string, optional) - Upper time bound for returned events (non-inclusive, in UTC)
    + since: `2017-11-03T17:00:00.000Z` (string, optional) - Lower time bound for returned events (inclusive, in UTC)

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
