## Permitted Roles [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members]

### List roles that have a permission on the hosts in a layer [GET]

List the roles that have a specified privilege on the hosts in a layer.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

**Permission required**: You must have the role whose members you are enumerating. If you have
the layer role, then you have the necessary permission.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of roles with specified permission|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to query for

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:@:layer/redis/use_host",
        "member": "cucumber:group:ops",
        "role": "conjur:@:layer/redis/use_host"
      },
      {
        "admin_option": false,
        "grantor": "cucumber:user:admin",
        "member": "conjur:@:layer/redis/admin_host",
        "role": "conjur:@:layer/redis/use_host"
      }
    ]
    ```
