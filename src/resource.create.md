## Create [/api/authz/{account}/resource/{kind}/{id}{?acting_as}]

### Create a new resource [PUT]

You can create resource of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the role.
This means that no one else will be able to see your role.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|201|Resource created successfully|
|403|Permission denied|
|409|A resource with that name already exists|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable_group (string) - Purpose of the resource
    + id: aws_keys (string) - Name of the resource, query-escaped
    + acting_as: demo%3Agroup%3Aops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json)
