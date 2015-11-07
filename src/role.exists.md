## Exists [/api/authz/{account}/roles/{kind}/{id}]

### Determine whether a role exists [HEAD]

Check for the existence of a role.
Only roles that you have `read` permission on will be searched.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)


**Response**

|Code|Description|
|----|-----------|
|204|Role exists|
|404|Role does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: ops (string) - ID of the role, do not query-escape

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
