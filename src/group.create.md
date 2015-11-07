## Create [/api/groups{?id,ownerid,gidnumber}]

### Create a new group [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the group.
This means that no one else will be able to see your group.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|201|Group created successfully|
|403|Permission denied|
|409|A group with that name already exists|

+ Parameters
    + id: ops (string, optional) - Name of the group, query-escaped
    + ownerid: conjur:group:security_admin (string, optionall) - Fully qualified ID of a Conjur role that will own the new group
    + gidnumber: 27001 (number, optional) - A GID number for the new group, primarily for use with LDAP

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id": "ops",
        "userid": "admin",
        "ownerid": "conjur:group:security_admin",
        "gidnumber": 27001,
        "roleid": "conjur:group:ops",
        "resource_identifier": "conjur:group:ops"
    }
    ```
