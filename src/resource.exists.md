## Exists [/api/authz/{account}/resources/{kind}/{id}]

### Determine whether a resource exists [HEAD]

Check for the existence of a resource.
Only resources that you have `read` permission on will be searched.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)


**Response**

|Code|Description|
|----|-----------|
|204|resource exists|
|404|resource does not exist|

+ Parameters
    + account: demo (string) - organization account name
    + kind: host (string) - kind of the resource, for example 'variable' or 'host'
    + id: redis001 (string) - ID of the resource, do not query-escape

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
