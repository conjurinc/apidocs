## Permitted Roles [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members]

### List roles that have a permission on the hosts [GET]

List the roles that have a specified privilege on the hosts in a layer.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of roles with specified permission|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + account: demo (string) - organization account name
    + layer: jenkins/slaves (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to query for

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      "demo:group:security_admin",
      "demo:user:bob"
    ]
    ```
