## Check [/api]

Check whether a role has a certain permission on a resource.

There are 2 routes here:
* The first route uses the currently logged-in user as the role.
* The second route allows you to *specify* the role on which to check permissions.

Note that in the examples, we are checking if a role can fry bacon.
Conjur defines resource and role types for common use cases, but you
are free to use your own custom types.

### Check own permissions [GET /api/authz/{account}/resources/{resource_kind}/{resource_id}/?check{&priviledge}]

In this example, we are checking if we have `fry` privilege on the resource `food:bacon`.

The response body is empty, privilege is communicated through the response status code.

**Permission required**

You must either:

* Be the owner of the resource
* Have some permission on the resource
* Be granted the role that you are checking (which includes your own role)

You are not allowed to check permissions of arbitrary roles or resources.

+ Parameters
    + account: demo (string) - organization account name
    + resource_kind: food (string) - kind of the resource, for example 'variable' or 'host'
    + resource_id: bacon (string) - ID of the resource you're checking
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Response 204
The privilege is held; the role is allowed to proceed with the transaction.

+ Response 403
The request is allowed, but the privilege is not held by the role.

+ Response 404
The role is not allowed to check permissions on this resource.

### Check another role's permissions [GET /api/authz/{account}/roles/{role_kind}/{role_id}/?check{&privilege,resource_id}]

In this example, we are checking if the user 'alice' has
`fry` privilege on the resource `food:bacon`.

The response body is empty, privilege is communicated through the response status code.

**Permission required**

You must either:

* Be the owner of the resource
* Have some permission on the resource
* Be granted the role that you are checking (which includes your own role)

You are not allowed to check permissions of arbitrary roles or resources.

+ Parameters
    + account: demo (string) - organization account name
    + role_kind: user (string) - kind of the role, for example 'user' or 'host'. If the role is not specified, the currently authenticated role is used.
    + role_id: alice (string) - ID of the role. If the role is not specified, the current authenticated role is used.
    + resource_id: food:bacon (string) - the kind and ID of the resource, joined by a colon
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Response 204
The privilege is held; the role is allowed to proceed with the transaction.

+ Response 403
The request is allowed, but the privilege is not held by the role.

+ Response 404
The role is not allowed to check permissions on this resource.
