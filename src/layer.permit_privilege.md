## Permit on Hosts [/api/authz/{account}/roles/@/layer/{layer}/{privilege}?members{&member}]

### Permit a privilege on hosts in a layer [PUT]

Create a privilege grant for hosts in a layer to a role.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Privilege granted|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + member: group:developers (string) - Qualified role name, do not query-escape

+ Request (application/json; charset=utf-8)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200
