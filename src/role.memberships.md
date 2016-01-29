## List memberships [/api/authz/{account}/roles/{kind}/{id}?all]

### List the roles a role is a member of [GET]

This route is the inverse of [role#members](/#reference/role/list-members).

Given a role X, the output is a list of roles that X is a member of.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Role memberships returned as JSON list|
|404|Role does not exist|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: ops (string) - ID of the role

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      "cucumber:group:ops",
      "cucumber:group:network",
      "cucumber:group:database"
    ]
    ```