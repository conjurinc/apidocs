## Create [/api/authz/{account}/resources/{kind}/{id}{?acting_as}]

:[deprecation_warning_4.8](partials/deprecation_warning_4.8.md)

### Create a new resource [PUT]

You can create resources of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the resource.
This means that no one else will be able to see your resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Resource created successfully|
|403|Permission denied|
|409|A resource with that name already exists|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - Purpose of the resource
    + id: aws_keys (string) - Name of the resource, query-escaped
    + acting_as: cucumber:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
