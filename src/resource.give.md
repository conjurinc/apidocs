## Give [/api/authz/{account}/resources/{kind}/{id}{?owner}]

### Give ownership of a resource to another role [PUT]

An owner is assigned on resource creation. Use this route to transfer that ownership to a new role.

In this example, we are transferring ownership of a variable to a group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Ownership granted|
|403|Permission denied|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - Purpose of the resource
    + id: dev/mongo/password (string) - Name of the resource, query-escaped
    + owner: cucumber:group:ops (string) - Fully-qualified Conjur ID of the new owner role, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200
