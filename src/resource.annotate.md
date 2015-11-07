## Annotate [/api/authz/{account}/annotations/{kind}/{id}{?name,value}]

### Annotate a resource with a key/value pair [PUT]

All resources can be annotated to make it easier to organize, search and perform automation on them.

An annotation is simply a key/value pair and can be any value.
In this example, we're applying the annotation `aws/account:ci` to the `jenkins/slaves` layer.

The key and value must be query-escaped:  `/` -> `%2F`, `:` -> `%3A`.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Annotation applied|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: redis (string) - ID of the resource you're annotating
    + name: aws:account (string) - Key for the annotation, query-escaped
    + value: ci (string) - Value for the annotation, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200
