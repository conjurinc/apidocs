## Deny [/api/authz/{account}/resources/{kind}/{id}/?deny{&privilege,role}]

:[deprecation_warning_4.8](partials/deprecation_warning_4.8.md)

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

**Permission required**: You must be the owner of the resource, or you must have `grant_option` on the
permission you are denying.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Privilege revoked|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: execute (string) - Privilege to deny
    + role: group:ops (string) - Qualified role name to revoke privilege from, do not query-escape

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
