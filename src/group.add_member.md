## Add Member [/api/authz/{account}/roles/group/{group}?members&member=user:{user}]

### Add a user to a group [PUT]

Adds a new user to an existing group. The user will assume all privileges of the group.

Passing `admin_option=true` allows the user to administer they group they are being
added to, adding and removing other members.

This operation is idempotent. If the user is already in the group,
adding it again will do nothing.

Both `group` and `user` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

**Permission required**: You must have the group role with `admin` option.
This is the same privilege required to grant the group role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|admin_option|Grant user adminship of group|no|`Boolean`|false|

**Response**

|Code|Description|
|----|-----------|
|200|Group membership granted to user|
|403|Permission denied|
|404|Existing group or user not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + group: ops (string) - ID of the group, query-escaped
    + user: alice (string) - Username of the user to add

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200
