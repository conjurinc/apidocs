## Exists [/api/authz/{account}/resources/{kind}/{id}]

### Determine whether a resource exists [HEAD]

Check for the existence of a resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)


**Response**

|Code|Description|
|----|-----------|
|200|resource exists and you have a privilege on it|
|403|the resource exists but you have no privilege on it|
|404|resource does not exist|

+ Parameters
    + account: cucumber (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: aws_keys (string) - ID of the resource, do not query-escape

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200
