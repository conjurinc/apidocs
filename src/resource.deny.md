## Deny [/api/authz/{account}/resources/{kind}/{id}/?deny{&privilege,role}]

### Deny a privilege on a resource [POST]

Deny a privilege for a resource on a role.
The only role with privileges on a newly-created resource is its owner.

Denying a privilege is the inverse of [permitting](/#reference/resource/permit) a privilege.

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
|204|Privilege revoked|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: use_host (string) - Privilege to deny
    + role: group:ops (string) - Qualified role name to revoke privilege from, do not query-escape

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
