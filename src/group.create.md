## Create [/api/groups]

### Create a new group [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the group.
This means that no one else will be able to see your group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the variable|no|`String`|"developers"|
|ownerid|Fully qualified ID of a Conjur role that will own the new group|no|`String`|"demo:group:security_admin"|
|gidnumber|A GID number for the new group, primarily for use with LDAP|no|`Number`|27001|

**Response**

|Code|Description|
|----|-----------|
|201|Group created successfully|
|403|Permission denied|
|409|A group with that name already exists|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {
            "id": "developers",
            "ownerid": "demo:group:security_admin",
            "gidnumber": 27001
        }
        ```

+ Response 201 (application/json)

    ```
    {
        "id": "developers",
        "userid": "demo",
        "ownerid": "demo:group:security_admin",
        "gidnumber": 27001,
        "roleid": "demo:group:developers",
        "resource_identifier": "demo:group:developers"
    }
    ```
