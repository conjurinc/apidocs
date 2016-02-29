## Remove Member [/api/authz/{account}/roles/group/{group}/?members&member=user:{user}]

### Remove a user from a group [DELETE]

Revoke a user's existing membership to the a group. This will remove all
group privileges from the user.

Both `group` and `user` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

**Permission required**: You must have the group role with `admin` option.
This is the same privilege required to grant the group role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Group membership removed from user|
|403|Permission denied|
|404|Existing group, user or membership not found|

+ Parameters
    + account: cucumber (string) - organization account name
    + group: ops (string) - ID of the group, query-escaped
    + user: alice (string) - Username of the user to add

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204