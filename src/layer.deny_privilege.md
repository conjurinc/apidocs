## Deny on Hosts [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members{&member}]

### Deny a privilege on hosts in a layer [DELETE]

Revoke a privilege grant for hosts in a layer to a role.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

**Permission required**: You must have the layer role with `admin` option. This is the same
privilege required to grant the layer role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Privilege revoked|
|403|Permission denied|
|404|Layer or privilege not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + member: group:developers (string) - Qualified role name, do not query-escape

+ Request (application/json; charset=utf-8)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
