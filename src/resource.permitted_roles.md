## Permitted Roles [/api/authz/{account}/roles/allowed_to/{privilege}/{kind}/{id}]

### List roles that have a permission on a resource [GET]

List the roles that have a specified privilege on a resource.

Privileges available are:

* `read`
* `execute`
* `update`
* `admin`

In this example, we're looking for roles that are allowed to update the value of a variable.

**Permission required**: You must own the resource or have a permission on the resource

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of roles with specified permission|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to check
    + privilege: execute (string) - Privilege to query for

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      "cucumber:group:security_admin",
      "cucumber:user:bob",
      "cucumber:user:kerry"
    ]
    ```
