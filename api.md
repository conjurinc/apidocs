FORMAT: 1A

# Conjur API

Welcome to the Conjur API documentation!

Any manipulation of resources in Conjur can be done through this API.

Most API calls require authentication. 
View the [Login](/#reference/authentication/login) and [Authenticate](/#reference/authentication/authenticate) routes
to see how to obtain an API key and auth token, respectively. Auth tokens expire after
8 minutes.

Use the public key you obtained when running `conjur init` for SSL verification when talking to your Conjur endpoint.
This is a *public* key, so you can check it into source control if needed.


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
$ echo -n myusername:mypassword | base64
```

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|HTTP Basic Auth|Basic YWRtaW46cGFzc3dvcmQ=|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the API key|
|400|The credentials were not accepted|

+ Request
    + Headers
    
        ```
        Authorization: Basic YWRtaW46cGFzc3dvcmQ=
        ```
        
+ Response 200 (text/html; charset=utf-8)

    ```
    14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc
    ```

## Authenticate [/api/authn/users/{login}/authenticate]

### Exchange a user login and API key for an API token [POST]

Conjur authentication is based on auto-expiring tokens, which are issued by Conjur when presented with both:

* A login name
* A corresponding password or API key

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
Take the response from the `authenticate` call and base64-encode it, stripping out newlines.

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

---

**Request Body**

Description|Required|Type|Example|
-----------|----|--------|-------|
Conjur API key|yes|`String`|"14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc"|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the raw data needed to create an auth token|
|400|The credentials were not accepted|

+ Parameters
    + login: admin (string) - login name for the user/host. For hosts this is `host/<hostid>`

+ Request (text/plain)
    + Body

        ```
        14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc
        ```

+ Response 200

    ```
    {
        "data": "lisa",
        "timestamp": "2015-10-24 20:31:50 UTC",
        "signature": "BpR0FEbQL8TpvpIjJ1awYr8uklvPecmXt-EpIIPcHpdAKBjoyrBQDZv8he1z7vKtF54H3webS0imvL0-UrHOE5yp_KB0fQdeF_z-oPYmaTywTcbwgsHNGzTkomcEUO49zeCmPdJN_zy_umiLqFJMBWfyFGMGj8lcJxcKTDMaXqJq5jK4e2-u1P0pG_AVnat9xtabL2_S7eySE1_2eK0SC7FHQ-7gY2b0YN7L5pjtHrfBMatg3ofCAgAbFmngTKCrtH389g2mmYXfAMillK1ZrndJ-vTIeDg5K8AGAQ7pz8xM0Cb0rqESWpYMc8ZuaipE5UMbmOym57m0uMuMftIJ_akBQZjb4zB-3IBQE25Sb4nrbFCgH_OyaqOt90Cw4397",
        "key": "15ab2712d65e6983cf7107a5350aaac0"
    }
    ```

## Group Variable

A `variable` is a 'secret' and can be any value. It is a `resource`, in RBAC terms.

[Read more](https://developer.conjur.net/key_concepts/secrets.html) about variables.

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
|201|Variable created successfully|
|403|Permission denied|
|409|A variable with that name already exists|

+ Request (application/json; ut)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {
            "id": "dev/mongo/password",
            "kind": "password",
            "mime_type": "text/plain",
            "value": "p89b12ep12puib"
        }
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "admin",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "conjur:user:admin",
        "resource_identifier": "conjur:variable:dev/mongo/password",
        "version_count": 1
    }
    ```

## List/Search [/api/authz/{account}/resources/variable{?search,limit,offset,acting_as}]

### List or search for variables [GET]

Lists all variables the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the variables with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of variables is returned|
|403|Permission denied|

+ Parameters
    + account: demo (string) - organization account name
    + search: mongo (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:variable:dev/mongo/password",
        "owner": "conjur:user:admin",
        "permissions": [
    
        ],
        "annotations": [
        ]
      }
    ]
    ```

## Show [/api/variables/{id}]

### Retrieve a variable's record [GET]

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
    + id: dev/mongo/password (string) - Name of the variable, query-escaped

+ Request (application/json; charset=utf-8)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "admin",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "conjur:user:admin",
        "resource_identifier": "conjur:variable:dev/mongo/password",
        "version_count": 1
    }
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
    + id: dev/mongo/password (string) - Name of the variable, query-escaped

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

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id":"dev/mongo/password",
        "userid":"admin",
        "mime_type":"text/plain",
        "kind":"secret",
        "ownerid":"conjur:user:admin",
        "resource_identifier":"conjur:variable:dev/mongo/password",
        "version_count":1
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
    + id: dev/mongo/password (string) - Name of the variable, query-escaped
    + version (string, optional) - Version of the variable to retrieve

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (text/plain; charset=utf-8)

    ```
    np89daed89p
    ```


## Group User

A `user` represents an identity for a human. It is a `role`, in RBAC terms.

[Read more](https://developer.conjur.net/reference/services/directory/user/) about users.

## Create [/api/users]

### Create a new user [POST]

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

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```
    
    + Body

          ```
          {
              "login":"alice",
              "password":"9p8nfsdafbp",
              "ownerid":"conjur:group:security_admin",
              "uidnumber":123456
          }
          ```

+ Response 201 (application/json; charset=utf-8)
    ```
    {
        "login":"alice",
        "userid":"admin",
        "ownerid":"conjur:group:security_admin",
        "uidnumber":123456,
        "roleid":"conjur:user:alice",
        "resource_identifier":"conjur:user:alice",
        "api_key":"3c6vwnk3mdtks82k7f23sapp93t6p1nagcergrnqw91b12sxc21zkywy"
    }
    ```

## Update [/api/users/{login}{?uidnumber}]

### Update a user record [PUT]

Update a user's UID number with this route.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

The new password, in the example "n82p9819pb12d12dsa".

**Response**

|Code|Description|
|----|-----------|
|204|The password/UID has been updated|
|401|Invalid or missing Authorization header|
|403|Permission denied|
|404|User not found|

+ Parameters
    + login: alice (string) - Login name of the user, query-escaped
    + uidnumber: `57000` (number, optional) - New UID number to set for the user

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

<!-- ## Update Password [/api/authn/users/password]

### Update a user's password [PUT]

Change a user's password with this route.

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

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

The new password, in the example "password".

**Response**

|Code|Description|
|----|-----------|
|204|The password/UID has been updated|
|401|Invalid or missing Authorization header|
|403|Permission denied|
|404|User not found|

+ Parameters
    + login: alice (string) - Login name of the user, query-escaped

+ Request(text/plain)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```
    
    + Body
    
        ```
        password
        ```

+ Response 204 -->

## List/Search [/api/authz/{account}/resources/user{?search,limit,offset,acting_as}]

### List or search for users [GET]

Lists all users the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the users with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of users is returned|
|403|Permission denied|

+ Parameters
    + account: demo (string) - organization account name
    + search: kenneth (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "demo:user:alice",
        "owner": "conjur:group:admin",
        "permissions": [
    
        ],
        "annotations": {
        }
      }
    ]
    ```

## Search by UID [/api/users/search{?uidnumber}]

### Search for users by UID number [GET]

If you set UID numbers for your users, you can search on that field.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of usernames matching the UID|
|403|Permission denied|

+ Parameters
    + uidnumber: `57000` (number) - UID to match on

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
        "alice"
    ]
    ```

## Show [/api/users/{login}]

### Retrieve a user's record [GET]

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

+ Response 200 (application/json; charset=utf-8)

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

## Group Group

A `group` represents a collection of users or groups. It is a `role` and a collection of `roles`, in RBAC terms.

[Read more](https://developer.conjur.net/reference/services/directory/group/) about groups.

## Create [/api/groups{?id,ownerid,gidnumber}]

### Create a new group [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the group.
This means that no one else will be able to see your group.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|201|Group created successfully|
|403|Permission denied|
|409|A group with that name already exists|

+ Parameters
    + id: ops (string, optional) - Name of the group, query-escaped
    + ownerid: conjur:group:security_admin (string, optionall) - Fully qualified ID of a Conjur role that will own the new group
    + gidnumber: 27001 (number, optional) - A GID number for the new group, primarily for use with LDAP

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id": "ops",
        "userid": "admin",
        "ownerid": "conjur:group:security_admin",
        "gidnumber": 27001,
        "roleid": "conjur:group:ops",
        "resource_identifier": "conjur:group:ops"
    }
    ```

## Update [/api/groups/{id}{?gidnumber}]

### Update a group record [PUT]

You can change a group's GID number with this route.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|The GID has been updated|
|401|Invalid or missing Authorization header|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + id: ops (string) - Name of the group, query-escaped
    + gidnumber: 63000 (number) - New GID number to set for the group

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## List/Search [/api/authz/{account}/resources/group{?search,limit,offset,acting_as}]

### List or search for groups [GET]

Lists all groups the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the groups with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of groups is returned|
|403|Permission denied|

+ Parameters
    + account: conjur (string) - organization account name
    + search: ops (string, optional) - Query for search, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:group:ops",
        "owner": "conjur:group:security_admin",
        "permissions": [
    
        ],
        "annotations": [
        ]
      }
    ]
    ```

## Search by GID [/api/groups/search{?gidnumber}]

### Search for groups by GID number [GET]

If you set GID numbers for your groups, you can search on that field.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of group names matching the GID|
|403|Permission denied|

+ Parameters
    + gidnumber: 63000 (number) - GID to match on

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
        "ops"
    ]
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
    + id: ops (string) - Name of the group, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "id":"ops",
        "userid":"conjur",
        "ownerid":"conjur:group:security_admin",
        "gidnumber":null,
        "roleid":"conjur:group:ops",
        "resource_identifier":"conjur:group:ops"
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
    + account: conjur (string) - Organization account name
    + id: ops (string) - Name of the group, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:group:security_admin",
        "member": "conjur:user:admin",
        "role": "conjur:group:security_admin"
      },
      {
        "admin_option": true,
        "grantor": "conjur:user:admin",
        "member": "conjur:user:dustin",
        "role": "conjur:group:security_admin"
      },
      {
        "admin_option": false,
        "grantor": "conjur:user:dustin",
        "member": "conjur:user:bob",
        "role": "conjur:group:security_admin"
      }
    ]
    ```

## Group Host

A `host` represents an identity for a non-human. This could be a VM, Docker container, CI job, etc.
It is both a `role` and `resource`, in RBAC terms.

Hosts are grouped into layers.

[Read more](https://developer.conjur.net/reference/services/directory/host/) about hosts.

## Create [/api/hosts/{?id,ownerid}]

### Create a new host [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the host.
This means that no one else will be able to see your host.

The API key for the host is returned in the response. This is the **only** time you
will see the API key, so save it somewhere if you want to be able to log in as the host
identity on the command line.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|201|Host created successfully|
|403|Permission denied|
|409|A host with that name already exists|

+ Parameters
    + id: redis001 (string, optional) - Name of the host, query-escaped
    + ownerid: conjur:group:ops (string, optional) - Fully qualified ID of a Conjur role that will own the new host

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
      "id": "redis001",
      "userid": "admin",
      "created_at": "2015-11-03T21:34:47Z",
      "ownerid": "conjur:group:ops",
      "roleid": "conjur:host:redis001",
      "resource_identifier": "conjur:host:redis001",
      "api_key": "3sqgnzs2yqtjgf3hx6fw6cdh8012hb6ehy1wh406eeg8ktj27jgabd"
    }
    ```

## List/Search [/api/authz/{account}/resources/host{?search,limit,offset,acting_as}]

### List or search for hosts [GET]

Lists all hosts the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the hosts with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of hosts is returned|
|403|Permission denied|

+ Parameters
    + account: conjur (string) - organization account name
    + search: redis (string, optional) - Query for search
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as: conjur:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:host:redis001",
        "owner": "conjur:group:ops",
        "permissions": [
          {
            "privilege": "read",
            "grant_option": false,
            "resource": "conjur:host:redis001",
            "role": "conjur:host:redis001",
            "grantor": "conjur:user:admin"
          }
        ],
        "annotations": []
      }
    ]
    ```

## Show [/api/hosts/{id}]

### Retrieve a host's metadata [GET]

This route returns information about a host.
The host's API key is not returned in this response.

Host IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Host metadata is returned|
|403|Permission denied|
|404|Host not found|

+ Parameters
    + id: redis001 (string) - Name of the host, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "id": "redis001",
      "userid": "admin",
      "created_at": "2015-11-03T21:33:17Z",
      "ownerid": "conjur:group:ops",
      "roleid": "conjur:host:redis001",
      "resource_identifier": "conjur:host:redis001"
    }
    ```

## List Layers [/api/authz/{account}/roles/host/{id}/?all]

### List the layers to which a host belongs [GET]

A host may belong to multiple layers at once.

Host IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|List of layers is returned|
|403|Permission denied|
|404|Host not found|

+ Parameters
    + account: conjur (string) - Organization account name
    + id: redis001 (string) - Name of the host, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
        "redis/nodes"
    ]
    ```

## Group Layer

A `layer` is a collection of hosts. It is a `role`, in RBAC terms.

Granting privileges on layers instead of the hosts themselves allows for easy auto-scaling.
A host assumes the permissions of the layer when it is enrolled.

[Read more](https://developer.conjur.net/reference/services/directory/layer/) about layers.

## Create [/api/layers/{?id,ownerid}]

### Create a new layer [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the layer.
This means that no one else will be able to see your layer.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the layer|no|`String`|"jenkins/slaves"|
|ownerid|Fully qualified ID of a Conjur role that will own the new layer|no|`String`|"demo:group:ops"|

**Response**

|Code|Description|
|----|-----------|
|201|Layer created successfully|
|403|Permission denied|
|409|A layer with that name already exists|

+ Parameters
    + id: redis (string, optional) - Name of the layer, query-escaped
    + ownerid: conjur:group:security_admin (string, optional) - Fully qualified ID of a Conjur role that will own the new layer

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
      "id": "redis",
      "userid": "admin",
      "ownerid": "conjur:group:ops",
      "roleid": "conjur:layer:redis",
      "resource_identifier": "conjur:layer:redis",
      "hosts": []
    }
    ```

## List/Search [/api/authz/{account}/resources/layer{?search,limit,offset,acting_as}]

### List or search for layers [GET]

Lists all layers the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the hosts with the `search` parameter.

You can also limit, offset and shorten the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of layers is returned|
|403|Permission denied|

+ Parameters
    + account: conjur (string) - organization account name
    + search: redis (string, optional) - Query for search
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return
    + acting_as (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:layer:redis",
        "owner": "conjur:group:ops",
        "permissions": [
          {
            "privilege": "read",
            "grant_option": false,
            "resource": "conjur:layer:redis",
            "role": "conjur:@:layer/redis/observe",
            "grantor": "conjur:user:admin"
          }
        ],
        "annotations": []
      }
    ]
    ```

## Show [/api/layers/{id}]

### Retrieve a layer's record [GET]

This route returns information about a layer, including its attached hosts.

Layer IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the layer.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Layer record is returned|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + id: redis (string) - Name of the layer, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "id": "redis",
      "userid": "admin",
      "ownerid": "conjur:group:ops",
      "roleid": "conjur:layer:redis",
      "resource_identifier": "conjur:layer:redis",
      "hosts": [
        "conjur:host:redis001"
      ]
    }
    ```

## Add Host [/api/layers/{id}/hosts{?hostid}]

### Add a host to a layer [POST]

Adds a new host to an existing layer. The host will assume all privileges of the layer.

This operation is idempotent: if the host is already in the layer, adding it again will do nothing.

Both `id` and `hostid` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|


**Response**

|Code|Description|
|----|-----------|
|201|Host added to the layer|
|403|Permission denied|
|404|Existing layer or host not found|

+ Parameters
    + id: redis (string) - ID of the layer, query-escaped
    + hostid: conjur:host:redis001 (string) - Fully qualified ID of the host to add, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
      "id": "redis",
      "userid": "admin",
      "ownerid": "conjur:group:ops",
      "roleid": "conjur:layer:redis",
      "resource_identifier": "conjur:layer:redis",
      "hosts": [
        "conjur:host:redis001"
      ]
    }
    ```

## Remove Host [/api/layers/{id}/hosts/{hostid}]

### Remove a host from a layer [DELETE]

Remove a host from an existing layer. All privileges the host gained through layer enrollment are revoked.

Both `id` and `hostid` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|


**Response**

|Code|Description|
|----|-----------|
|204|Host removed from the layer|
|403|Permission denied|
|404|Existing layer or host not found|

+ Parameters
    + id: redis (string) - ID of the layer, query-escaped
    + hostid: conjur:host:redis001 (string) - Fully qualified ID of the host to remove, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Permitted Roles [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members]

### List roles that have a permission on the hosts in a layer [GET]

List the roles that have a specified privilege on the hosts in a layer.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of roles with specified permission|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + account: conjur (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to query for

+ Request (application/json; charset=utf-8)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:@:layer/redis/use_host",
        "member": "conjur:group:ops",
        "role": "conjur:@:layer/redis/use_host"
      },
      {
        "admin_option": false,
        "grantor": "conjur:user:admin",
        "member": "conjur:@:layer/redis/admin_host",
        "role": "conjur:@:layer/redis/use_host"
      }
    ]
    ```

## Permit on Hosts [/api/authz/{account}/roles/@/layer/{layer}/{privilege}?members{&member}]

### Permit a privilege on hosts in a layer [PUT]

Create a privilege grant for hosts in a layer to a role.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Privilege granted|
|403|Permission denied|
|404|Layer not found|

+ Parameters
    + account: conjur (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + member: group:ops (string) - Qualified role name, do not query-escape

+ Request (application/json; charset=utf-8)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200

## Deny on Hosts [/api/authz/{account}/roles/@/layer/{layer}/{privilege}/?members{&member}]

### Deny a privilege on hosts in a layer [DELETE]

Revoke a privilege grant for hosts in a layer to a role.

Privileges available are:

* `use_host` - Maps to `execute` privilege
* `admin_host` - Maps to `update` privilege

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Privilege revoked|
|403|Permission denied|
|404|Layer or privilege not found|

+ Parameters
    + account: conjur (string) - organization account name
    + layer: redis (string) - Name of the layer, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + member: group:ops (string) - Qualified role name, do not query-escape

+ Request (application/json; charset=utf-8)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

<!--

## Group Role

A `role` is an actor in the system, in the classical sense of role-based access control. 
Roles are the entities which receive permission grants.

[Read more](https://developer.conjur.net/reference/services/authorization/role/) about roles.

## Create [/api/authz/{account}/roles/{kind}/{id}{?acting_as}]

### Create a new role [PUT]

You can create roles of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the role.
This means that no one else will be able to see your role.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|201|Role created successfully|
|403|Permission denied|
|409|A role with that name already exists|

+ Parameters
    + account: demo (string) - organization account name
    + kind: chatbot (string) - Purpose of the role
    + id: hubot (string) - Name of the role, query-escaped
    + acting_as: demo%3Agroup%3Aops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json)

## Exists [/api/authz/{account}/roles/{kind}/{id}]

### Determine whether a role exists [HEAD]

Check for the existence of a role.
Only roles that you have `read` permission on will be searched.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|


**Response**

|Code|Description|
|----|-----------|
|204|Role exists|
|404|Role does not exist|

+ Parameters
    + account: demo (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: v1/ops (string) - ID of the role, do not query-escape

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## List members [/api/authz/{account}/roles/{kind}/{id}?members]

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
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: v1/ops (string) - ID of the role

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

A `resource` is a record on which permissions are defined. 
They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/) abour resources.

## Create [/api/authz/{account}/resource/{kind}/{id}{?acting_as}]

### Create a new resource [PUT]

You can create resource of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the role.
This means that no one else will be able to see your role.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

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
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json)

## Exists [/api/authz/{account}/resources/{kind}/{id}]

### Determine whether a resource exists [HEAD]

Check for the existence of a resource.
Only resources that you have `read` permission on will be searched.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|


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
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Show [/api/authz/{account}/annotations/{kind}/{id}/]

### Retrieve a resources's record [GET]

Retrieves a resource's metadata, including annotations.

**Permission Required**

`read` permission on the resource.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|The response body contains the resource's record|
|403|You don't have permission to view the record|
|404|No record exists with the given ID|

+ Parameters
    + account: demo (string) - organization account name
    + kind: chatbot (string) - kind of the resource, for example 'variable' or 'host'
    + id: hubot (string) - ID of the resource to show

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    {
      "id": "demo:chatbot:hubot",
      "owner": "demo:group:ops",
      "permissions": [
    
      ],
      "annotations": [
          {
            "resource_id": 36,
            "name": "client",
            "value": "slack",
            "created_at": "2015-11-04T21:06:14.208+00:00",
            "updated_at": "2015-11-04T21:06:14.208+00:00"
          }
      ]
    }
    ```

## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists all resources the calling identity has `read` privilege on.

Run a full-text search of the resources with the `search` parameter.

You can also limit, offset and shorten the resulting list.

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

## Annotate [/api/authz/{account}/annotations/{kind}/{id}{?name,value}]

### Annotate a resource with a key/value pair [PUT]

All resources can be annotated to make it easier to organize, search and perform automation on them.

An annotation is simply a key/value pair and can be any value.
In this example, we're applying the annotation `aws/account:ci` to the `jenkins/slaves` layer.

The key and value must be query-escaped:  `/` -> `%2F`, `:` -> `%3A`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Annotation applied|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: demo (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: jenkins/slaves (string) - ID of the resource you're annotating
    + name: aws%2Faccount (string) - Key for the annotation, query-escaped
    + value: ci (string) - Value for the annotation, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

## List Annotations [/api/authz/{account}/annotations/{kind}/{id}]

### List the annotations on a resource [GET]

There is no specific route for listing annotations, but the record of a resource
lists all annotations when you retrieve it. You can then parse the JSON to get the annotations list.

**Permission required**: `read` privilege on the resource.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Resource metadata is returned|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: demo (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: jenkins/slaves (string) - ID of the resource to show

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

    ```
    {
      "id": "demo:layer:jenkins/slaves",
      "owner": "demo:group:security_admin",
      "permissions": [
        {
          "privilege": "read",
          "grant_option": false,
          "resource": "demo:layer:jenkins/slaves",
          "role": "demo:@:layer/jenkins/slaves/observe",
          "grantor": "demo:user:terry"
        }
      ],
      "annotations": [
        {
          "resource_id": 25,
          "name": "aws/account",
          "value": "ci",
          "created_at": "2015-11-04T20:51:19.716+00:00",
          "updated_at": "2015-11-04T20:51:19.716+00:00"
        }
      ]
    }
    ```

## Give [/api/authz/{account}/resources/{kind}/{id}{?owner}]

### Give ownership of a resource to another role [PUT]

An owner is assigned on resource creation. Use this route to transfer that ownership to a new role.

In this example, we are transferring ownership of a variable to a group.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Ownership granted|
|403|Permission denied|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable (string) - Purpose of the resource
    + id: aws%2Faccess_key_id (string) - Name of the resource, query-escaped
    + owner: demo%3Agroup%3Aops (string) - Fully-qualified Conjur ID of the new owner role, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json)

## Check [/api]

Check whether a role has a certain permission on a resource.

There are 2 routes here:
* The first route uses the currently logged-in user as the role.
* The second route allows you to *specify* the role on which to check permissions.

Note that in the examples, we are checking if a role can fry bacon.
Conjur defines resource and role types for common use cases, but you
are free to use your own custom types.

### Check your own permissions [GET /api/authz/{account}/resources/{kind}/{id}/?check{&priviledge}]

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
    + kind: food (string) - kind of the resource, for example 'variable' or 'host'
    + id: bacon (string) - ID of the resource you're checking
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204


### Check another role's permissions [GET /api/authz/{account}/roles/{kind}/{id}/?check{&privilege,resource_id}]

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
    + kind: user (string) - kind of the role, for example 'user' or 'host'. If the role is not specified, the currently authenticated role is used.
    + id: alice (string) - ID of the role. If the role is not specified, the current authenticated role is used.
    + resource_id: food:bacon (string) - the kind and ID of the resource, joined by a colon
    + privilege: fry (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Permit [/api/authz/{account}/resources/{kind}/{id}/?permit{&privilege,role}]

### Permit a privilege on a resource [POST]

Create a privilege grant on a resource to a role.

Built-in privileges available are:

* `read`
* `execute`
* `update`
* `admin`

These have special meanings in Conjur, but you can create your own as needed.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|Privilege granted|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: use_host (string) - Privilege to permit
    + role: group:ops (string) - Qualified role name to grant privilege to, do not query-escape

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Deny [/api/authz/{account}/resources/{kind}/{id}/?deny{&privilege,role}]

### Deny a privilege on a resource [POST]

Deny a privilege for a resource on a role.
The only role with privileges on a newly-created resource is its owner.

Denying a privilege is the inverse of [permitting](/#reference/resource/permit) a privilege.

Built-in privileges available are:

* `read`
* `execute`
* `update`
* `admin`

These have special meanings in Conjur, but you can create your own as needed.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|Privilege revoked|
|403|Permission denied|
|404|Resource not found|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: use_host (string) - Privilege to deny
    + role: group:ops (string) - Qualified role name to revoke privilege from, do not query-escape

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Group Audit

Every privilege modification, variable retrieval and SSH action is logged to an immutable audit trail in Conjur.

Audit records can be retrieved via the API for everything or a single role/resource.
Fetching all audit records can return a very large response, so it is best to the the `limit` parameter.

## All [/api/audit{?limit,offset}]

### Fetch all audit events [GET]

Fetch audit events for all roles and resources the calling identity has `read` privilege on.

You can limit and offset the resulting list of events.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|403|Permission denied|

+ Parameters
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept-Encoding: gzip, deflate
        ```

+ Response 200 (application/json)

    ```
    [
        {
          "resources": [],
          "roles": [
            "demo:user:lisa",
            "demo:@:layer/jenkins/slaves/observe",
            "demo:@:layer/jenkins/slaves/use_host"
          ],
          "action": "grant",
          "role": "demo:@:layer/jenkins/slaves/observe",
          "member": "demo:@:layer/jenkins/slaves/use_host",
          "grantor": "demo:user:lisa",
          "timestamp": "2015-11-03T20:11:47.789Z",
          "event_id": "8bf37b524d95df2ab4c1fe7e3f89267d",
          "id": 96,
          "user": "demo:user:lisa",
          "acting_as": "demo:user:lisa",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/roles/@/layer/jenkins/slaves/observe?members&member=demo:@:layer/jenkins/slaves/use_host",
            "method": "PUT",
            "params": {
              "members": null,
              "member": "demo:@:layer/jenkins/slaves/use_host",
              "controller": "roles",
              "action": "update_member",
              "account": "demo",
              "role": "@/layer/jenkins/slaves/observe",
              "admin_option": null
            },
            "uuid": "3f0a0cfe-eef1-4a6d-a4a5-a0ebc1f20fc6"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:user:lisa",
            "account": "demo"
          },
          "kind": "role"
        }
        ... // more events
    ]
    ```

## Single [/api/audit/{kind}/{id}{?limit,offset}]

### Fetch audit events for a single role/resource [GET]

Fetch audit events for a role/resource the calling identity has `read` privilege on.

You can limit and offset the resulting list of events.

`id` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|
|Accept-Encoding|Encoding required to accept a large response|gzip, deflate|


**Response**

|Code|Description|
|----|-----------|
|200|JSON list of audit events is returned|
|403|Permission denied|
|404|Role/resource not found|

+ Parameters
    + kind: roles (string) - Type of object, 'roles' or 'resources'
    + id: demo%3Ahost%3Aredis001 (string) - Fully qualified ID of a Conjur role/resource, query-escaped
    + limit: 100 (number, optional) - Limit the number of records returned
    + offset: 0 (number, optional) - Set the starting record index to return

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept-Encoding: gzip, deflate
        ```

+ Response 200 (application/json)

    ```
    [
        {
          "resources": [],
          "roles": [
            "demo:user:lisa",
            "demo:group:security_admin",
            "demo:host:redis001"
          ],
          "action": "create",
          "role_id": "demo:host:redis001",
          "creator": "demo:group:security_admin",
          "role": "demo:host:redis001",
          "timestamp": "2015-11-03T21:33:17.974Z",
          "event_id": "c5e9788790c51fb334d9517fdd603ce4",
          "id": 183,
          "user": "demo:user:lisa",
          "acting_as": "demo:group:security_admin",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/roles/host/redis001",
            "method": "PUT",
            "params": {
              "acting_as": "demo:group:security_admin",
              "controller": "roles",
              "action": "create",
              "account": "demo",
              "role": "host/redis001"
            },
            "uuid": "a432a32e-875e-489f-8f18-6aa3ef6df0cc"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:group:security_admin",
            "account": "demo"
          },
          "kind": "role"
        },
        {
          "resources": [
            "demo:host:redis001"
          ],
          "roles": [
            "demo:user:lisa",
            "demo:host:redis001"
          ],
          "resource": "demo:host:redis001",
          "action": "permit",
          "privilege": "read",
          "grantee": "demo:host:redis001",
          "grantor": "demo:user:lisa",
          "timestamp": "2015-11-03T21:33:18.012Z",
          "event_id": "8faec6a55a4e299abd737af9e0187d3e",
          "id": 185,
          "user": "demo:user:lisa",
          "acting_as": "demo:user:lisa",
          "request": {
            "ip": "74.97.185.119",
            "url": "http://localhost:5100/demo/resources/host/redis001?permit&privilege=read&role=demo:host:redis001",
            "method": "POST",
            "params": {
              "permit": null,
              "privilege": "read",
              "role": "demo:host:redis001",
              "controller": "resources",
              "action": "grant_permission",
              "account": "demo",
              "kind": "host",
              "identifier": "redis001"
            },
            "uuid": "3c50d04a-0f34-420b-8027-f9e4df3b882a"
          },
          "conjur": {
            "domain": "authz",
            "env": "appliance",
            "user": "demo:user:lisa",
            "role": "demo:user:lisa",
            "account": "demo"
          },
          "kind": "resource"
        }
        ... // more events
    ]
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
-->