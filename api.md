FORMAT: 1A

# Conjur API

Welcome to the Conjur API documentation.

Any manipulation of resources in Conjur can be done through this RESTful API.
Most API calls require authentication.

## Group Authentication

## Login [/api/authn/users/login]

### Exchange a user login and password for an API key [GET]

Once the API key is obtained, it may be used to rapidly obtain authentication tokens,
which are required to use most other Conjur services.

Passwords are stored in the Conjur database using bcrypt with a work factor of 12.
Therefore, login is a fairly expensive operation.

If you login through the command-line interface, you can print your current
logged-in identity with the `conjur authn whoami` CLI command.

The value for the `Authorization` Basic Auth header can be obtained with:
```
$ echo myusername:mypassword | base64
```

+ Request (application/json)
    + Headers

            Authorization: Basic ZHVzdGluOm43dStpbHVzMQo=

+ Response 200

    ```
    # The response body is the API key.
    1dsvap135aqvnv3z1bpwdkh92052rf9csv20510ne2gqnssc363g69y
    ```

+ Response 400

    ```
    # The credentials were not accepted.
    ```

## Authenticate [/api/authn/users/{login}/authenticate]

### Exchange a user login and API key for an API token [POST]

Conjur authentication is based on auto-expiring tokens, which are issued by Conjur when presented with both:

* A login name
* A corresponding password or API key

---

The Conjur Token provides authentication for API calls.

For API usage, it is ordinarily passed as an HTTP Authorization "Token" header.

```
Authorization: Token token="eyJkYX...Rhb="
```

Properties of the token include:

* It is JSON.
* It carries the login name and other data in a payload.
* It is signed by a private authentication key, and verified by a corresponding public key.
* It carries the signature of the public key for easy lookup in a public key database.
* It has a fixed life span of several minutes, after which it is no longer valid.

Before the token can be used to make subsequent calls to the API, it must be formatted.
Take the response from the `authenticate` call and base64-encode it and strip out newlines.

```
token=$(echo -n $response | base64 | tr -d '\r\n')
```

The token can now be used for Conjur API access.

```
curl --cacert <certfile> \
-H "Authorization: Token token=\"$token\"" \
<route>
```

NOTE: If you have the Conjur CLI installed you can get a pre-formatted token with:

```
conjur authn authenticate -H
```

+ Parameters
    + login (string) - login name for the user/host. For hosts this is `host/<hostid>`

+ Request
    + Body

        ```
        1dsvap135aqvnv3z1bpwdkh92052rf9csv20510ne2gqnssc363g69y
        ```

+ Response 200

    ```
    {
        "data": "dustin",
        "timestamp": "2015-10-24 20:31:50 UTC",
        "signature": "BpR0FEbQL8TpvpIjJ1awYr8uklvPecmXt-EpIIPcHpdAKBjoyrBQDZv8he1z7vKtF54H3webS0imvL0-UrHOE5yp_KB0fQdeF_z-oPYmaTywTcbwgsHNGzTkomcEUO49zeCmPdJN_zy_umiLqFJMBWfyFGMGj8lcJxcKTDMaXqJq5jK4e2-u1P0pG_AVnat9xtabL2_S7eySE1_2eK0SC7FHQ-7gY2b0YN7L5pjtHrfBMatg3ofCAgAbFmngTKCrtH389g2mmYXfAMillK1ZrndJ-vTIeDg5K8AGAQ7pz8xM0Cb0rqESWpYMc8ZuaipE5UMbmOym57m0uMuMftIJ_akBQZjb4zB-3IBQE25Sb4nrbFCgH_OyaqOt90Cw4397",
        "key": "15ab2712d65e6983cf7107a5350aaac0"
    }
    ```

+ Response 400

    ```
    # The credentials were not accepted.
    ```

## Group Role

A `role` is an actor in the system, in the classical sense of role-based access control. Roles are the entities which receive permission grants.

[Read more](https://developer.conjur.net/reference/services/authorization/role/)

## Get members [/api/authz/{account}/roles/{role_kind}/{role_id}?members]

### Lists the roles that have been the recipient of a role grant [GET]

The creator of the role is always a role member and role administrator.

If role "A" is created by user "U" and then granted to roles "B" and "C",
then the members of role "A" are [ "U", "B", "C" ].

Role members are not expanded transitively.
Only roles which have been explicitly granted the role in question are listed.

**Permission Required**: Admin option on the role

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

+ Parameters
    + account: demo (string) - organization account name
    + role_kind: group (string) - kind of the role, for example 'group' or 'layer'
    + role_id: v1/ops (string) - ID of the role

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    [
      {
        "admin_option": true,
        "grantor": "demo:group:v1/ops",
        "member": "demo:group:security_admin",
        "role": "demo:group:v1/ops"
      },
      {
        "admin_option": false,
        "grantor": "demo:user:demo",
        "member": "demo:user:donna",
        "role": "demo:group:v1/ops"
      }
    ]
    ```

## Grant to / Revoke from [/api/authz/{account}/roles/{role_a}/?members&member={role_b}]

### Grant a role to another role [PUT]

All of this role's privileges are thereby granted to the new role.

When granted with `admin_option`, the grantee (given-to) role can grant the grantor (given-by) role to others.

`admin_option` is passed in the request body.

**Permission Required**: Admin option on the role

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|admin_option|Allow grantee admin rights|no|`Boolean`|true|

**Response**

|Code|Description|
|----|-----------|
|200|Role granted|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {admin_option: true}
        ```

+ Response 200 (text/plain)

    ```
    Role granted
    ```


### Revoke a granted role [DELETE]

Inverse of `role#grant_to`.

**Permission Required**: Admin option on the role

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Role revoked|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (text/plain)

    ```
    Role revoked
    ```

## Group Resource

A `resource` is a record on which permissions are defined. They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/)

## List [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### Find and list resources [GET]

This command includes features such as:

* Full-text search of resource ids and annotations
* Filtering by resource kind
* Search offset and limit
* Display full resource JSON, or IDs only

**Permission Required**

The result only includes resources on which the current role has some privilege.
In other words, resources on which you have no privilege are invisible to you.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of visible resources|

+ Parameters
    + account: demo (string) - organization account name
    + kind: host (string) - kind of the resource, for example 'variable' or 'host'
    + search: ec2 (string, optional) - search string
    + limit (number, optional) - limits the number of response records
    + offset (number, optional) - offset into the first response record

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    [
        {
            "id": "conjurops:host:ec2/i-2e3c83df",
            "owner": "conjurops:group:v4/build",
            "permissions": [
              {
                "privilege": "execute",
                "grant_option": false,
                "resource": "conjurops:host:ec2/i-2e3c83df",
                "role": "conjurops:@:layer/build-0.1.0/jenkins/use_host",
                "grantor": "conjurops:deputy:production/jenkins-2.0/jenkins-slaves"
              },
              {
                "privilege": "read",
                "grant_option": false,
                "resource": "conjurops:host:ec2/i-2e3c83df",
                "role": "conjurops:host:ec2/i-2e3c83df",
                "grantor": "conjurops:deputy:production/jenkins-2.0/jenkins-slaves"
              }
            ],
            "annotations": {
            }
          }
    ]
    ```

## Check [/api]

Check whether a role has a certain permission on a resource.

There are 2 routes here:
* The first route uses the currently logged-in user as the role.
* The second route allows you to *specify* the role on which to check permissions.

Note that in the examples, we are checking if a role can fry bacon.
Conjur defines resource and role types for common use cases, but you
are free to use your own custom types.

### Check your own permissions [GET /api/authz/{account}/resources/{resource_kind}/{resource_id}/?check{&priviledge}]

In this example, we are checking if we have `fry` privilege on the resource `food:bacon`.

The response body is empty, privilege is communicated through the response status code.

**Permission required**

You must either:

* Be the owner of the resource
* Have some permission on the resource
* Be granted the role that you are checking (which includes your own role)

You are not allowed to check permissions of arbitrary roles or resources.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|The privilege is held; you are allowed to proceed with the transaction.|
|403|The request is allowed, but the privilege is not held by you.|
|409|You are not allowed to check permissions on this resource.|

+ Parameters
    + account: demo (string) - organization account name
    + resource_kind: food (string) - kind of the resource, for example 'variable' or 'host'
    + resource_id: bacon (string) - ID of the resource you're checking
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204


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

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|The privilege is held; the role is allowed to proceed with the transaction.|
|403|The role is not allowed to check permissions on this resource.|
|404|The request is allowed, but the privilege is not held by the role.|

+ Parameters
    + account: demo (string) - organization account name
    + role_kind: user (string) - kind of the role, for example 'user' or 'host'. If the role is not specified, the currently authenticated role is used.
    + role_id: alice (string) - ID of the role. If the role is not specified, the current authenticated role is used.
    + resource_id: food:bacon (string) - the kind and ID of the resource, joined by a colon
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Group User

A `user` represents an identity for a human.

## Create [POST /api/users]

Create a Conjur user.

The response when creating a user contains the user's API key.
This is to support passwordless users.
When other methods (show, for example) return the user as a JSON document,
the API key is **not** included.

When a user is created, the user is owned by itself as default,
and this is not generally what you want.
You can use the `ownerid` parameter to give ownership of the role
to a particular group when it is created.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|login|Username for the new user|yes|`String`|"alice"|
|password|Password for the new user|no|`String`|"9p8nfsdafbp"|
|ownerid|Fully qualified ID of a Conjur role that will own the new user|no|`String`|"demo:group:security_admin"|
|uidnumber|A UID number for the new user, primarily for use with LDAP |no|`Number`|123456|

**Response**

|Code|Description|
|----|-----------|
|201|User created successfully|
|403|Permission denied|
|409|A user with this login already exists|
|500|The group specified by `ownerid` doesn't exist, or some other server error occured.|

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```
    + Body

      ```
      {
          "login":"alice",
          "password":"9p8nfsdafbp",
          "ownerid":"demo:group:security_admin",
          "uidnumber":123456
      }
      ```

+ Response 201 (application/json)
    ```
    {
        "login":"alice",
        "userid":"admin",
        "ownerid":"demo:group:security_admin",
        "uidnumber":123456,
        "roleid":"demo:user:alice",
        "resource_identifier":"demo:user:alice",
        "api_key":"3c6vwnk3mdtks82k7f23sapp93t6p1nagcergrnqw91b12sxc21zkywy"
    }
    ```

## Show [GET /api/users/{login}]

Retrieve a user's record.

The response for this method is similar to that from create,
but it **does not contain the user's API key**.

The login parameter must be url encoded.

**Permission Required**

`read` permission on the user's resource.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|The response body contains the user's record|
|403|You don't have permission to view the record|
|404|No user exists with the given login name|

+ Parameters
    + login: alice (string) - The user's login

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    {
      "login":"alice",
      "userid":"admin",
      "ownerid":"ci:group:developers",
      "uidnumber":1234567,
      "roleid":"ci:user:alice",
      "resource_identifier":"ci:user:alice"
    }
    ```

## Update Password [PUT /api/users/]

Change a user's password.

In order to change a user's password, you must be able to prove that you
are the user. You can do so by giving an `Authorization` header with
either a Conjur authentication token or HTTP Basic Auth containing
the user's login and old password.
Note that the user whose password is to be updated is determined by
the value of the `Authorization` header.

This operation will also replace the user's API key with a securely
generated random value. You can fetch the new API key using the
Conjur CLI's `authn login` method.

---

**Header**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur authentication token or Http Basic Auth|"Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="|

**Request Body**

The new password, in the example "n82p9819pb12d12dsa".

**Response**

|Code|Description|
|----|-----------|
|204|The password has been updated|
|401|Invalid or missing Authorization header|

+ Request
    + Headers

        ```
        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
        ```
    + Body

        ```
        n82p9819pb12d12dsa
        ```

+ Response 204

## Group Group

A `group` represents a collection of users.

## Create [/api/groups]

### Create a new group [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the group.
This means that no one else will be able to see your group.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the variable|no|`String`|"developers"|
|ownerid|Fully qualified ID of a Conjur role that will own the new group|no|`String`|"demo:group:security_admin"|
|gidnumber|A GID number for the new group, primarily for use with LDAP|no|`Number`|27001|

**Response**

|Code|Description|
|----|-----------|
|201|Group created successfully|
|403|Permission denied|
|409|A group with that name already exists|

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {
            "id": "developers",
            "ownerid": "demo:group:security_admin",
            "gidnumber": 27001
        }
        ```

+ Response 201 (application/json)

    ```
    {
        "id": "developers",
        "userid": "demo",
        "ownerid": "demo:group:security_admin",
        "gidnumber": 27001,
        "roleid": "demo:group:developers",
        "resource_identifier": "demo:group:developers"
    }
    ```

## Show [/api/groups/{id}]

### Retrieve a group's metadata [GET]

Returns information about a group.

Group IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the group.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Group metadata is returned|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + id: tech%2Fops (string) - Name of the group, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    {
        "id":"tech/ops",
        "userid":"demo",
        "ownerid":"demo:group:security_admin",
        "gidnumber":null,
        "roleid":"demo:group:tech/ops",
        "resource_identifier":"demo:group:tech/ops"
    }
    ```

## List Members [/api/authz/{account}/roles/group/{id}?members]

### List a group's members [GET]

Lists the direct members of a group.

Group IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the group.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|List of group members returned|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + account: demo (string) - Organization account name
    + id: tech%2Fops (string) - Name of the group, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    [
      {
        "admin_option": true,
        "grantor": "demo:group:security_admin",
        "member": "demo:user:admin",
        "role": "demo:group:security_admin"
      },
      {
        "admin_option": true,
        "grantor": "demo:user:admin",
        "member": "demo:user:dustin",
        "role": "demo:group:security_admin"
      },
      {
        "admin_option": false,
        "grantor": "demo:user:dustin",
        "member": "demo:user:bob",
        "role": "demo:group:security_admin"
      }
    ]
    ```

## Group Variable

A `variable` is a 'secret' and can be any value.

## Create [/api/variables]

### Create a new variable [POST]

A variable can be created with or without an initial value.
If you don't give the variable an ID, one will be randomly generated.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the variable|no|`String`|"dev/mongo/password"|
|ownerid|Fully qualified ID of a Conjur role that will own the new variable|no|`String`|"demo:group:developers"|
|mime_type|Media type of the variable|yes|`String`|"text/plain"|
|kind|Purpose of the variable|no|`String`|"password"|
|value|Value of the variable|no|`String`|"p89b12ep12puib"|

**Response**

|Code|Description|
|----|-----------|
|201|User created successfully|
|403|Permission denied|
|409|A variable with that name already exists|

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {
            "id": "dev/mongo/password",
            "ownerid": "demo:group:developers",
            "kind": "password",
            "mime_type": "text/plain",
            "value": "p89b12ep12puib"
        }
        ```

+ Response 201 (application/json)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "demo",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "demo:group:developers",
        "resource_identifier": "demo:variable:dev/mongo/password",
        "version_count": 1
    }
    ```

## Show [/api/variables/{id}]

### Retrieve a variable's metadata [GET]

This route returns information about a variable, but **not** the
variable's value. Use the [variable#value](#reference/variable/value)
route to retrieve variable values.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the variable

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Variable metadata is returned|
|403|Permission denied|
|404|Variable not found|

+ Parameters
    + id: dev%2Fmongo%2Fpassword (string) - Name of the variable, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "demo",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "demo:group:developers",
        "resource_identifier": "demo:variable:dev/mongo/password",
        "version_count": 1
    }
    ```

## Value [/api/variables/{id}/value?{version}]

### Retrieve the value of a variable [GET]

By default this returns the latest version of a variable, but you can retrieve any earlier version as well.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Variable value is returned|
|403|Permission denied|
|404|Variable, or requested version of the value, not found|

+ Parameters
    + id: dev%2Fmongo%2Fpassword (string) - Name of the variable, query-escaped
    + version (string, optional) - Version of the variable to retrieve

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (text/plain)

    ```
    p89b12ep12puib
    ```

## Values Add [/api/variables/{id}/values]

### Add a value to a variable [POST]

Variable ids must be escaped in the url, e.g., `'/' -> '%2F'`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|value|New value to set for the variable|yes|`String`|"np89daed89p"|

**Response**

|Code|Description|
|----|-----------|
|201|Value added|
|403|Permission denied|
|404|Variable not found|
|422|Value malformed or missing|

+ Parameters
    + id: dev%2Fmongo%2Fpassword (string) - Name of the variable, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {
            "value": "np89daed89p"
        }
        ```

+ Response 201 (application/json)

    ```
    {
        "id":"dev/mongo/password",
        "userid":"demo",
        "mime_type":"text/plain",
        "kind":"secret",
        "ownerid":"demo:group:developers",
        "resource_identifier":"demo:variable:dev/mongo/password",
        "version_count":2
    }
    ```

## Group Utilities

## Health [/health]

### Perform a health check on the server [GET]

This method attempts an internal HTTP or TCP connection to each Conjur service.
It also attempts a simple transaction against all internal databases.

The response body is JSON that can be examined for additional details.

---

**Response**

|Code|Description|
|----|-----------|
|200|Server is healthy|
|502|Server is not healthy|

+ Response 200

    ```
    {
      "services":
        {
          "host-factory":"ok","core":"ok","pubkeys":"ok","audit":"ok",
          "authz":"ok","authn":"ok","ldap":"ok","ok":true
        },
      "database":{"ok":true,"connect":{"main":"ok"}},
      "ok":true
    }
    ```

+ Response 502

    ```
    {
      "services":
        {
          "host-factory":"ok","core":"ok","pubkeys":"ok","audit":"error",
          "authz":"ok","authn":"ok","ldap":"ok","ok":false
        },
      "database":{"ok":true,"connect":{"main":"ok"}},
      "ok":false
    }
    ```
