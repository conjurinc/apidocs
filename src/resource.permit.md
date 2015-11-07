## Permit [/api/authz/{account}/resources/{kind}/{id}/?permit{&privilege,role}]

### Permit a privilege on a resource [POST]

Create a privilege grant on a resource to a role.

Built-in privileges available are:

* `read`
* `execute`
* `update`
* `admin`

These have special meanings in Conjur, but you can create your own as needed.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Privilege granted|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: execute (string) - Privilege to permit
    + role: group:ops (string) - Qualified role name to grant privilege to, do not query-escape

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
