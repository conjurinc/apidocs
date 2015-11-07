## Check [/api]

Check whether a role has a certain permission on a resource.

There are 2 routes here:
* The first route uses the currently logged-in user as the role.
* The second route allows you to *specify* the role on which to check permissions.

Note that in the examples, we are checking if a role can fry bacon.
Conjur defines resource and role types for common use cases, but you
are free to use your own custom types.

### Check your own permissions [GET /api/authz/{account}/resources/{kind}/{id}/?check=true{&privilege}]

In this example, we are checking if we have `execute` privilege on the variable `dev/mongo/password`.

The response body is empty; privilege is communicated through the response status code.

**Permission required**

You must either:

* Be the owner of the resource
* Have some permission on the resource
* Be granted the role that you are checking (which includes your own role)

You are not allowed to check permissions of arbitrary roles or resources.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|The privilege is held; you are allowed to proceed with the transaction.|
|403|The request is allowed, but the privilege is not held by you.|
|409|You are not allowed to check permissions on this resource.|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource you're checking
    + privilege: execute (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204


### Check another role's permissions [GET /api/authz/{account}/roles/{kind}/{id}/?check{&privilege,resource_id}]

In this example, we are checking if the group `ops` has
`execute` privilege on the variable `dev/mongo/password`.

The response body is empty, privilege is communicated through the response status code.

**Permission required**

You must either:

* Be the owner of the resource
* Have some permission on the resource
* Be granted the role that you are checking (which includes your own role)

You are not allowed to check permissions of arbitrary roles or resources.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|The privilege is held; the role is allowed to proceed with the transaction.|
|403|The role is not allowed to check permissions on this resource.|
|404|The request is allowed, but the privilege is not held by the role.|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'user' or 'host'. If the role is not specified, the currently authenticated role is used.
    + id: ops (string) - ID of the role. If the role is not specified, the current authenticated role is used.
    + resource_id: variable:dev/mongo/password (string) - the kind and ID of the resource, joined by a colon
    + privilege: execute (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
