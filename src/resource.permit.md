## Permit [/api/authz/{account}/resources/{kind}/{id}/?permit{&privilege,role}]

:[deprecation_warning_4.8](partials/deprecation_warning_4.8.md)

### Permit a privilege on a resource [POST]

Create a privilege grant on a resource to a role.

Built-in privileges available are:

* `read`
* `execute`
* `update`
* `admin`

These have special meanings in Conjur, but you can create your own as needed.

**Permission required**: You must be the owner of the resource, or you must have `grant_option` on the
permission you are giving.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|grant_option|Allow transfer of privilege to other roles|no|`Boolean`|false|

**Response**

|Code|Description|
|----|-----------|
|204|Privilege granted|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: execute (string) - Privilege to permit
    + role: group:ops (string) - Qualified role name to grant privilege to, do not query-escape

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
