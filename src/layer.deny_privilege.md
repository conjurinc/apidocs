## Deny on Hosts [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members{&member}]

### Deny a privilege on hosts in a layer [DELETE]

Revoke a privilege grant for hosts in a layer to a role.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Privilege removed|
|403|Permission denied|
|404|Layer or privilege not found|

+ Parameters
    + account: demo (string) - organization account name
    + layer: jenkins/slaves (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + member: user:bob (string) - Qualified role name, do not query-escape

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)
