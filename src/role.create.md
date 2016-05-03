## Create [/api/authz/{account}/roles/{kind}/{id}{?acting_as}]

### Create a new role [PUT]

You can create roles of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the role.
This means that no one else will be able to see your role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|201|Role created successfully|
|403|Permission denied|
|405|A role with that name already exists|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: chatbot (string) - Purpose of the role
    + id: hubot (string) - Name of the role, query-escaped
    + acting_as: cucumber:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json)

    ```
        {
            "id":"cucumber:chatbot:hubot",
            "created_by":"cucumber:user:alice"
        }
    ```