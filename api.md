FORMAT: 1A
HOST: https://conjur.myorg.com

# Conjur API

Welcome to the Conjur API documentation!

Any manipulation of roles, resources and permissions in Conjur can be done through this API.

# Authentication

Most API calls require an authentication access token. To obtain an access token as a user:

1. Use a username and password to obtain an API key (refresh token) with the [Authentication > Login](/#reference/authentication/login) route.
2. Use the API key to obtain an access token with the [Authentication > Authenticate](/#reference/authentication/authenticate) route. 

Access tokens expire after 8 minutes. You need to obtain a new token after it expires.
Token expiration and renewal is handled automatically by the 
Conjur [CLI](https://developer.conjur.net/cli) and [client libraries](https://developer.conjur.net/clients).

## SSL verification

Use the public key you obtained when running `conjur init` for SSL verification when talking to your Conjur endpoint.
This is a *public* key, so you can check it into source control if needed.

For example, with curl:

```
$ curl --cacert <certfile> ...
```

# Examples

## Obtain an access token

Let's say your username for Conjur is `samantha`, and your password is `hfsdfp91opifouhw`.
Your Conjur endpoint is hosted at `https://conjur.mybigco.com`.

You have already obtained the public SSL cert by running `conjur init` against your endpoint; the cert was saved as
`~/conjur-mybigco.pem`.

Let's get your API key (refresh token) with the [Authentication > Login](/#reference/authentication/login) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
--user samantha:hfsdfp91opifouhw \
https://conjur.mybigco.com/api/authn/users/login

14m9cf91wfsesv1kkhevdywm2wvqy6s8sk53z1ngtazp1t9tykc
```

Great, you now have your refresh token! Let's use that to obtain an access token we can use for further requests.

Using the [Authentication > Authenticate](/#reference/authentication/authenticate) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
--data "14m9cf91wfsesv1kkhevdywm2wvqy6s8sk53z1ngtazp1t9tykc" \
https://conjur.mybigco.com/api/authn/users/samantha/authenticate

{
    "data": "samantha",
    "timestamp": "2015-10-24 20:31:50 UTC",
    "signature": "BpR0FEb...w4397",
    "key": "15ab2712d65e6983cf7107a5350aaac0"
}
```

We now have our access token in *raw* format. To be able to use it for future requests, we must encode it.

`$response` in the following command is the JSON response from the last API call.

```
$ token=$(echo -n $response | base64 | tr -d '\r\n')
```

Now that you have your encoded token, you can use it to call any other API route. 
For example, adding setting a new value for the variable `redis/password`:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
--data "mynewsecretvalue" \
https://conjur.mybigco.com/api/variables/redis%2Fpassword/values
```

Note that you can use the Conjur CLI to obtain an access token as well, by running `conjur authn authenticate -H`.

[Here is an example](https://github.com/conjurinc/apidocs/blob/master/get_auth_token.sh) 
of obtaining a formatted auth token with a bash script.

---

## Create a host-factory token

Let's say we want to create a new token for an existing host factory.

The host factory's name is `prod/redis_factory`. This factory generates token that allow hosts to enroll in the
`prod/redis` layer, which has permission to access the credentials for your production redis cluster.

You've already [obtained an access token](/#introduction/examples/obtain-an-auth-token) and set it to the bash variable `token`.

Let's set the host factory token to expire in one hour. Expiration timestamps are in 
[ISO8601 format](http://ruby-doc.org/stdlib-2.1.1/libdoc/time/rdoc/Time.html#class-Time-label-Converting+to+a+String)
and must be URL-encoded.

So, if right now is 2:01pm EST on Nov 16th 2015, one hour from now in ISO8601 is `2015-11-16T14:01:00-05:00`.
The timestamp must be URL-encoded in the route.

Create the host factory token with the [Host Factory > Create Token](/#reference/host-factory/create-token) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/host_factories/prod%2Fredis_factory/tokens?expiration=2015-11-16T14%3A01%3A00-05%3A00

[
  {
    "token": "3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q32",
    "expiration": "2015-11-16T20:01:00Z"
  }
]
```

The expiration timestamp in the response is in UTC time.

Now you can use this host factory token to create hosts pre-enrolled in the `prod/redis_factory` layer using
the [Host Factory > Create Host](/#reference/host-factory/create-host) route.

```
$ hftoken="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q32"

$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$hftoken\"" \
https://conjur.mybigco.com/api/host_factories/hosts?id=redis002

{
  "id": "redis002",
  "userid": "deputy/prod/redis_factory",
  "created_at": "2015-11-16T22:57:14Z",
  "ownerid": "conjur:group:ops",
  "roleid": "conjur:host:redis002",
  "resource_identifier": "conjur:host:redis002",
  "api_key": "14x82x72syhnnd1h8jj24zj1kqd2j09sjy3tddwxc35"
}
```

---

## Permit a group to read a variable

Let's say you want to allow your `mobile/developers` to read a [Firebase](https://www.firebase.com) key stored in Conjur.

The key is stored in the Conjur variable `firebase.com/mobile/secret-token` and owned by the group `security_admin`.

You've already [obtained an access token](/#introduction/examples/obtain-an-auth-token) and set it to the bash variable `token`.

For this example, your Conjur org is `mybigco`, this is the `orgaccount` parameter you gave to `evoke configure` when you
set up your Conjur install. You can also view your Conjur org in the CLI with `conjur authn whoami`.

Okay, so let's give those mobile developers access with the [Resource > Permit](/#reference/resource/permit) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/authz/account/mybigco/variable/firebase.com%2Fmobile%2Fsecret-token/?permit&privilege=execute&role=group:mobile/developers
```

You just gave the group `mobile/developers` the privilege `execute` on the variable `firebase.com/mobile/secret-token`.
This means that everyone in that group can now fetch the firebase key from the variable.

We can check that that is indeed the case with the [Resource > Check](/#reference/resource/check) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/authz/account/mybigco/roles/mobile%2Fdevelopers/?check&privilege=execute&resource_id=variable:firebase.com/mobile/secret-token
```

A response code of 204 means that the permission exists.

# Group Authentication

## Login [/api/authn/users/login]

### Exchange a user login and password for an API key [GET]

Sending your Conjur username and password via HTTP Basic Auth to this route returns
an API key.

Once this API key is obtained, it may be used to rapidly obtain authentication tokens by calling the
[Authenticate](http://docs.conjur.apiary.io/#reference/authentication/authenticate) route.
An authentication token is required to use most other parts of the Conjur API.

The value for the `Authorization` Basic Auth header can be obtained with:

```
$ echo -n myusername:mypassword | base64
```

If you log in through the command-line interface, you can print your current
logged-in identity with the `conjur authn whoami` CLI command.

Passwords are stored in the Conjur database using bcrypt with a work factor of 12.
Therefore, login is a fairly expensive operation.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|HTTP Basic Auth|Basic YWRtaW46cGFzc3dvcmQ=|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the API key|
|401|The credentials were not accepted|

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

### Exchange a user login and API key for an access token [POST]

Conjur authentication is based on auto-expiring access tokens, which are issued by Conjur when presented with both:

* A login name
* A corresponding password or API key (aka 'refresh token')

The Conjur Access Token provides authentication for API calls.

For API usage, it is ordinarily passed as an HTTP Authorization "Token" header.

```
Authorization: Token token="eyJkYX...Rhb="
```

Before the access token can be used to make subsequent calls to the API, it must be formatted.
Take the response from the this call and base64-encode it, stripping out newlines.

```
token=$(echo -n $response | base64 | tr -d '\r\n')
```

The access token can now be used for Conjur API access.

```
curl --cacert <certfile> \
-H "Authorization: Token token=\"$token\"" \
<route>
```

NOTE: If you have the Conjur CLI installed you can get a pre-formatted access token with:

```
conjur authn authenticate -H
```

Properties of the access token include:

* It is JSON.
* It carries the login name and other data in a payload.
* It is signed by a private authentication key, and verified by a corresponding public key.
* It carries the signature of the public key for easy lookup in a public key database.
* It has a fixed life span of several minutes, after which it is no longer valid.

---

**Request Body**

Description|Required|Type|Example|
-----------|----|--------|-------|
Conjur API key|yes|`String`|"14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc"|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the raw data needed to create an access token|
|401|The credentials were not accepted|

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

## Update [/api/authn/users/update{?id,cidr}]

### Update user attributes [PUT]

This method updates attributes of a User.

The principle use of this method is to change the IP restriction (IP address(es) or CIDR(s))
of a user. This method can be applied to any Conjur identity, but is most often used on
hosts.

**Permissions required**:

Any authenticated identity can update its own record, providing it's coming from a valid IP address.
Basic authorization (username plus password or API key) must be provided.

An authenticated identity can update the record of a different user if it has `update` privilege on the
other user's resource. In this case, access token is accepted as authentication.

### Supported version

Conjur 4.6 and later.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|HTTP Basic Auth|Basic YWRtaW46cGFzc3dvcmQ=|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the JSON of the User record|
|401|The Basic auth credentials were not accepted|

+ Parameters
    + id: alice (string, optional) - Id of the user to update. If not provided, the current authenticated user is updated.
    + cidr: 192.0.2.0 (string array, optional) - New CIDR list for the user.

+ Request
    + Headers
    
        ```
        Authorization: Basic YWRtaW46cGFzc3dvcmQ=
        ```
        
+ Response 200 (text/html; charset=utf-8)

    ```
    {
      "cidr": [ "192.0.2.0", "192.0.3.0/24" ]
    }
    ```

## Rotate API Key [/api/authn/users/api_key{?id}]

### Rotate the API key [PUT]

This method replaces the API key of an authn user with a new, securely random 
API key. The new API key is returned as the response body.

This request must be authenticated by Basic authentication using the existing 
API key or password of the user. A Conjur access token cannot be used to rotate
the API key.

**Permissions required**:

Any authenticated identity can rotate its own API key, providing it's coming from a valid IP address.
Basic authorization (username plus password or API key) must be provided.

An authenticated identity can rotate the API key of a different user if it has `update` privilege on the
other user's resource. In this case, access token is accepted as authentication.

### Supported version

Conjur 4.6 or higher.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|HTTP Basic Auth|Basic YWRtaW46cGFzc3dvcmQ=|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the API key|
|401|The Basic auth credentials were not accepted|

+ Parameters
    + id: alice (string, optional) - Id of the user to rotate. If not provided, the current authenticated user's API
    key is rotated.

+ Request
    + Headers
    
        ```
        Authorization: Basic YWRtaW46cGFzc3dvcmQ=
        ```
        
+ Response 200 (text/html; charset=utf-8)

    ```
    14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc
    ```

# Group Variable

A `variable` is a 'secret' and can be any value. It is a `resource`, in RBAC terms.

[Read more](https://developer.conjur.net/key_concepts/secrets.html) about variables.

## Create [/api/variables]

### Create a new variable [POST]

A variable can be created with or without an initial value.
If you don't give the variable an ID, one will be randomly generated.

Note that you can give the variable an initial value, but this is optional.
Use the [Variable > Values Add](http://docs.conjur.apiary.io/#reference/variable/values-add) 
route to set values for variables.

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

+ Request (application/json)
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

**Permission required**:

`read` privilege on the variable.

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

**Permission Required**:

`execute` privilege on the variable.

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

## Values [/api/variables/values{?vars}]

### Retrieve the values of multiple variables at once [GET]

If you need to retrieve the values of multiple variables at once, this route is much more
efficient than [variable#value](/#reference/variable/value).


Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission Required**:

`execute` privilege on all variables to be retrieved.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON map of variables names to values is returned|
|403|Permission denied|
|404|One or more of the variables was not found|

+ Parameters
    + vars: dev/mongo/password,dev/redis/password (string) - Comma-separated list of variable IDs to fetch, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "dev/mongo/password": "np89daed89p",
      "dev/redis/password": "8912dbp9bu1pub"
    }
    ```

+ Response 404 (application/json; charset=utf-8)

    ```
    {
      "error": {
        "kind": "RecordNotFound",
        "message": "variable 'staging/mongo/password' not found",
        "details": {
          "kind": "variable",
          "id": "staging/mongo/password"
        }
      }
    }
    ```


# Group User

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

## Update Password [/api/authn/users/password]

### Update a user's password [PUT]

Change a user's password with this route.

In order to change a user's password, you must be able to prove that you
are the user. You can do so by giving an `Authorization` header with
either a Conjur authentication token or HTTP Basic Auth containing
the user's login and old password.
Note that the user whose password is to be updated is determined by
the value of the `Authorization` header.

In this example, we are updating the password of the user `alice`.
We set her password as '9p8nfsdafbp' when we created the user, so to generate
the HTTP Basic Auth token on the command-line:

```
$ echo -n alice:9p8nfsdafbp | base64
YWxpY2U6OXA4bmZzZGFmYnA=
```

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
|422|New password not present in request body|

+ Request (text/plain)
    + Headers
    
        ```
        Authorization: Basic YWxpY2U6OXA4bmZzZGFmYnA=
        ```
    
    + Body
    
        ```
        password
        ```

+ Response 204

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

# Group Group

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

# Group Host

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

# Group Layer

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
    + ownerid: conjur:group:ops (string, optional) - Fully qualified ID of a Conjur role that will own the new layer

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

Run a full-text search of the layers with the `search` parameter.

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
    + member: group:developers (string) - Qualified role name, do not query-escape

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
    + member: group:developers (string) - Qualified role name, do not query-escape

+ Request (application/json; charset=utf-8)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

# Group Host Factory

The `Host Factory` is a web service that enables code and scripts to create Hosts and add them to specific Layers, 
without having to grant the scripts full administrative privileges on the layers. 

A typical flow:

1. You create a host factory and attach it to a layer through the Policy DSL.
2. You (or an automation tool) generate an expiring host factory token.
3. When a new host starts, it uses this token to enroll itself into the layer, assuming the layer's permissions.

To use the Host Factory from the Conjur CLI, install the host-factory plugin:

```
conjur plugin install host-factory
conjur hostfactory -h
```

[Read more](https://developer.conjur.net/reference/services/host_factory) about the Host Factory.

## Create [/api/host_factories/{?id,roleid,layers%5B%5D,ownerid}]

### Create a new host factory [POST]

Each Host Factory *acts as* a distinct Conjur role, which is specified when the host factory is created. 
All Hosts created by the Host Factory will be owned by this designated role.

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the Host Factory.
This means that no one else will be able to see your Host Factory.


**Permissions required**:

* The role specified by `roleid` must have adminship on the layer(s) specified by `layer`.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|201|Host factory created successfully|
|403|Permission denied|
|422|A host factory with that ID already exists|

+ Parameters
    + id: redis_factory (string, optional) - ID of the host factory, query-escaped
    + roleid: conjur:group:ops (string) - Fully qualified ID of a Conjur role that the host factory will act as, query-escaped
    + ownerid: conjur:group:security_admin (string, optional) - Fully qualified ID of a Conjur role that will own the new host factory, query-escaped
    + layers%5B%5D: redis (string) - ID of the layer the host-factory can enroll hosts for, query-escaped. Can be specified multiple times.

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
      "id": "redis_factory",
      "layers": [
        "redis"
      ],
      "roleid": "conjur:group:ops",
      "resourceid": "conjur:host_factory:redis_factory",
      "tokens": [],
      "deputy_api_key": "3g6v6h83bsk76r3cb638h2dce4kz35dsej81c304rp306wzqa1z8eqch"
    }
    ```

## List/Search [/api/authz/{account}/resources/host_factory{?search,limit,offset,acting_as}]

### List or search for host factories [GET]

Lists all host factories the calling identity has `read` privilege on.

You can switch the role to act as with the `acting_as` parameter.

Run a full-text search of the host factories with the `search` parameter.

You can also limit and offset the resulting list.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of host factories is returned|
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
        "id": "conjur:host_factory:redis_factory",
        "owner": "conjur:group:security_admin",
        "permissions": [],
        "annotations": []
      }
    ]
    ```

## Show [/api/host_factories/{id}]

### Retrieve a host factory's record [GET]

This route returns information about a host factory, including its attached hosts.

This response includes the host factory's deputy API key and all valid tokens.

Host factory IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host factory.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Host factory record is returned|
|403|Permission denied|
|404|Host factory not found|

+ Parameters
    + id: redis_factory (string) - ID of the host factory, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "id":"redis_factory",
        "layers":[],
        "roleid":"conjur:group:ops",
        "resourceid":"conjur:host_factory:redis_factory",
        "tokens":[
            {
              "token": "30vf6aa3b6x326sdnwj93cx5rzd3dwmhva3828m8x32xsveh5qb4x5",
              "expiration": "2015-11-13T18:42:02Z"
            }
        ],
        "deputy_api_key":"3g6v6h83bsk76r3cb638h2dce4kz35dsej81c304rp306wzqa1z8eqch"
    }
    ```

## Create Token [/api/host_factories/{id}/tokens{?expiration,count}]

### Create a new host factory token [POST]

By passing a host factory token to a new host, it can enroll itself into a specified layer. 
This route creates those tokens.

Host factory tokens expire after a certain amount of time. By default, this is one hour. Use the
`expiration` parameter to set your own expiration timestamp. The timestamp is in 
[ISO8601 format](http://ruby-doc.org/stdlib-2.1.1/libdoc/time/rdoc/Time.html#class-Time-label-Converting+to+a+String)
and must be URL-encoded.

*Example*

`2015-11-16T14:36:57-05:00` -> `2015-11-16T14%3A36%3A57-05%3A00`

Generate multiple tokens at once with the `count` parameter. By default, one token is created.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of created tokens is returned|
|403|Permission denied|
|404|Host factory not found|

+ Parameters
    + id: redis_factory (string) - ID of the host factory, query-escaped
    + expiration: `2017-12-16T14:36:57-05:00` (string, optional) - Expiration timestamp (ISO8601), query-escaped
    + count: 2 (number, optional) - Number of tokens to create

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "token": "3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v",
        "expiration": "2015-11-13T20:17:00Z"
      },
      {
        "token": "34m4qev29dm73vk4pccp2e53t7x3ffy7e81d9hn0m3b9103j1h09fjn",
        "expiration": "2015-11-13T20:17:00Z"
      }
    ]
    ```

## Show Token [/api/host_factories/tokens/{id}/]

### Retrieve a host factory token's metadata [GET]

This route returns information about a host factory token, including its expiration timestamps
and the layers to which it is tied.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|200|Token metadata returned|
|403|Permission denied|
|404|Host factory token not found|

+ Parameters
    + id: y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w (string) - ID of the token

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "token": "y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w",
      "expiration": "2015-11-13T20:38:51Z",
      "host_factory": {
        "id": "redis_factory",
        "layers": [
          "redis"
        ],
        "roleid": "conjur:group:ops",
        "resourceid": "conjur:host_factory:redis_factory"
      }
    }
    ```

## Revoke Token [/api/host_factories/tokens/{id}]

### Revoke a host factory token [DELETE]

Host factory tokens are not automatically revoked when they expire. Revoke a token when you want to disallow
its use before its expiration timestamp.

When you revoke a token, hosts can no longer use it to enroll in a layer.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|Token revoked|
|403|Permission denied|
|404|Host factory token not found|

+ Parameters
    + id: y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w (string) - ID of the token

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

## Create Host [/api/host_factories/hosts{?id}]

### Create a new host using a host factory token [POST]

To create a new host with a host factory token, you pass the token in the `Authorization` header, like so:

```
Authorization: Token token="<insert host factory token here>"
```

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Host factory token|Token token="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v"|

**Response**

|Code|Description|
|----|-----------|
|201|JSON record of host created returned|
|403|Permission denied|
|422|Host with that ID already exists or token is invalid for the layer|

+ Parameters
    + id: redis002 (string) - ID of the host to create, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v"
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id":"redis002",
        "userid":"deputy/redis_factory",
        "created_at":"2015-11-13T22:57:14Z",
        "ownerid":"conjur:group:ops",
        "roleid":"conjur:host:redis002",
        "resource_identifier":"conjur:host:redis002",
        "api_key":"14x82x72syhnnd1h8jj24zj1kqd2j09sjy3tddwxc35cmy5nx33ph7"
    }
    ```

# Group Role

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
|405|A role with that name already exists|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: chatbot (string) - Purpose of the role
    + id: hubot (string) - Name of the role, query-escaped
    + acting_as: conjur:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 201

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
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: ops (string) - ID of the role, do not query-escape

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

**Response**

|Code|Description|
|----|-----------|
|200|Role memberships returned as JSON list|
|404|Role does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'group' or 'layer'
    + id: ops (string) - ID of the role

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "admin_option": true,
        "grantor": "conjur:group:ops",
        "member": "conjur:group:security_admin",
        "role": "conjur:group:ops"
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
    + account: conjur (string) - organization account name
    + role_a: user/alice (string) - ID of the owner role `{kind}/{id}`, query-escaped
    + role_b: group:ops (string) - Qualified ID of the role we're granting membership to

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

    + Body

        ```
        {admin_option: true}
        ```

+ Response 200

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
|204|Role revoked|
|403|Permission denied|
|404|Role does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + role_a: user/alice (string) - ID of the owner role
    + role_b: group:ops (string) - ID of the role we're granting membership to

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

# Group Resource

A `resource` is a record on which permissions are defined. 
They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/) abour resources.

## Create [/api/authz/{account}/resources/{kind}/{id}{?acting_as}]

### Create a new resource [PUT]

You can create resources of custom kinds to better match your infrastructure and workflows.

If you don't provide `acting_as`, your user will be the owner of the resource.
This means that no one else will be able to see your resource.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur auth token|Token token="eyJkYX...Rhb="|

**Response**

|Code|Description|
|----|-----------|
|204|Resource created successfully|
|403|Permission denied|
|409|A resource with that name already exists|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: variable_group (string) - Purpose of the resource
    + id: aws_keys (string) - Name of the resource, query-escaped
    + acting_as: conjur:group:ops (string, optional) - Fully-qualified Conjur ID of a role to act as, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

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
|200|resource exists|
|404|resource does not exist|

+ Parameters
    + account: conjur (string) - organization account name
    + kind: variable_group (string) - kind of the resource, for example 'variable' or 'host'
    + id: aws_keys (string) - ID of the resource, do not query-escape

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200

## Show [/api/authz/{account}/resources/{kind}/{id}/]

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
    + account: conjur (string) - organization account name
    + kind: variable_group (string) - kind of the resource, for example 'variable' or 'host'
    + id: aws_keys (string) - ID of the resource to show

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "id": "conjur:variable_group:aws_keys",
      "owner": "conjur:group:ops",
      "permissions": [],
      "annotations": []
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
    + kind: variable_group (string) - kind of the resource, for example 'variable' or 'host'
    + search: aws_keys (string, optional) - search string
    + limit (string, optional) - limits the number of response records
    + offset (string, optional) - offset into the first response record

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "conjur:variable_group:aws_keys",
        "owner": "conjur:group:ops",
        "permissions": [],
        "annotations": []
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
    + account: conjur (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: redis (string) - ID of the resource you're annotating
    + name: aws:account (string) - Key for the annotation, query-escaped
    + value: ci (string) - Value for the annotation, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200

## List Annotations [/api/authz/{account}/resources/{kind}/{id}]

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
    + account: conjur (string) - organization account name
    + kind: layer (string) - kind of the resource, for example 'variable' or 'host'
    + id: redis (string) - ID of the resource to show

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "id":"conjur:layer:redis",
        "owner":"conjur:group:security_admin",
        "permissions":[
            {
                "privilege":"read",
                "grant_option":false,
                "resource":"conjur:layer:redis",
                "role":"conjur:@:layer/redis/observe",
                "grantor":"conjur:user:admin"
            }
        ],
        "annotations":[
            {
                "resource_id":18,
                "name":"aws:account",
                "value":"ci",
                "created_at":"2015-11-07T16:51:50.446+00:00",
                "updated_at":"2015-11-07T16:53:37.524+00:00"
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
    + account: conjur (string) - organization account name
    + kind: variable (string) - Purpose of the resource
    + id: dev/mongo/password (string) - Name of the resource, query-escaped
    + owner: conjur:group:ops (string) - Fully-qualified Conjur ID of the new owner role, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 200

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
    + account: conjur (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: execute (string) - Privilege to permit
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
    + account: conjur (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource to act on, do not query-escape
    + privilege: execute (string) - Privilege to deny
    + role: group:ops (string) - Qualified role name to revoke privilege from, do not query-escape

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

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
    + account: conjur (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + id: dev/mongo/password (string) - ID of the resource you're checking
    + privilege: execute (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

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
    + account: conjur (string) - organization account name
    + kind: group (string) - kind of the role, for example 'user' or 'host'. If the role is not specified, the currently authenticated role is used.
    + id: ops (string) - ID of the role. If the role is not specified, the current authenticated role is used.
    + resource_id: variable:dev/mongo/password (string) - the kind and ID of the resource, joined by a colon
    + privilege: execute (string) - name of the desired privilege, for example 'execute' or 'update'

+ Request
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        ```

+ Response 204

# Group Audit

Every privilege modification, variable retrieval and SSH action is logged to an immutable audit trail in Conjur.

Audit records can be retrieved via the API for everything or a single role/resource.
Fetching all audit records can return a very large response, so it is best to the the `limit` parameter.

## All [/api/audit]

### Fetch all audit events [GET]

Fetch audit events for all roles and resources the calling identity has `read` privilege on.

The example shows a single audit event returned.

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

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept: */*
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "resources":[
    
        ],
        "roles":[
          "conjur:user:admin"
        ],
        "action":"all_roles",
        "role":"conjur:user:admin",
        "filter":[
          "conjur:group:security_admin"
        ],
        "allowed":true,
        "timestamp":"2015-11-07T17:24:21.085Z",
        "event_id":"4af71f3bf6648b299c59c4ffc8a142db",
        "id":1122,
        "user":"conjur:user:admin",
        "acting_as":"conjur:user:admin",
        "request":{
          "ip":"127.0.0.1",
          "url":"http://localhost:5100/conjur/roles/user/admin?all\u0026filter%5B%5D=conjur%3Agroup%3Asecurity_admin",
          "method":"GET",
          "params":{
            "all":null,
            "filter":[
              "conjur:group:security_admin"
            ],
            "controller":"roles",
            "action":"all_roles",
            "account":"conjur",
            "role":"user/admin"
          },
          "uuid":"b0ced92e-9a1c-461b-aa51-b04211f7d307"
        },
        "conjur":{
          "domain":"authz",
          "env":"appliance",
          "user":"conjur:user:admin",
          "role":"conjur:user:admin",
          "account":"conjur"
        },
        "kind":"role"
      },
      {
        "resources":[
          "conjur:user:alice"
        ],
        "roles":[
          "conjur:user:admin"
        ],
        "resource":"conjur:user:alice",
        "action":"check",
        "privilege":"update",
        "allowed":true,
        "timestamp":"2015-11-07T17:24:21.118Z",
        "event_id":"ec72aa9c08f005d6c8598ad055594d88",
        "id":1123,
        "user":"conjur:user:admin",
        "acting_as":"conjur:user:admin",
        "request":{
          "ip":"127.0.0.1",
          "url":"http://localhost:5100/conjur/resources/user/alice?check=true\u0026privilege=update",
          "method":"GET",
          "params":{
            "check":"true",
            "privilege":"update",
            "controller":"resources",
            "action":"check_permission",
            "account":"conjur",
            "kind":"user",
            "identifier":"alice"
          },
          "uuid":"aef23372-2933-4aa1-9597-99b7bbcfe22b"
        },
        "conjur":{
          "domain":"authz",
          "env":"appliance",
          "user":"conjur:user:admin",
          "role":"conjur:user:admin",
          "account":"conjur"
        },
        "kind":"resource"
      }
    ]
    ```

## Single [/api/audit/{kind}/{id}]

### Fetch audit events for a single role/resource [GET]

Fetch audit events for a role/resource the calling identity has `read` privilege on.

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
    + id: conjur:host:redis001 (string) - Fully qualified ID of a Conjur role/resource, query-escaped

+ Request (application/json)
    + Headers
    
        ```
        Authorization: Token token="eyJkYX...Rhb="
        Accept: */*
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "resources": [],
        "roles": [
          "conjur:user:admin",
          "conjur:group:ops",
          "conjur:host:redis001"
        ],
        "action": "create",
        "role_id": "conjur:host:redis001",
        "creator": "conjur:group:ops",
        "role": "conjur:host:redis001",
        "timestamp": "2015-11-07T04:41:22.406Z",
        "event_id": "a06f5f34da97a544abdd1a38cd337829",
        "id": 57,
        "user": "conjur:user:admin",
        "acting_as": "conjur:group:ops",
        "request": {
          "ip": "127.0.0.1",
          "url": "http://localhost:5100/conjur/roles/host/redis001",
          "method": "PUT",
          "params": {
            "acting_as": "conjur:group:ops",
            "controller": "roles",
            "action": "create",
            "account": "conjur",
            "role": "host/redis001"
          },
          "uuid": "300422d8-342a-416c-a597-8bb698b0361a"
        },
        "conjur": {
          "domain": "authz",
          "env": "appliance",
          "user": "conjur:user:admin",
          "role": "conjur:group:ops",
          "account": "conjur"
        },
        "kind": "role"
      }
    ]
    ```

# Group Utilities

## Health [/health]

### Perform a health check on the server [GET]

This method attempts an internal HTTP or TCP connection to each Conjur service.
It also attempts a simple transaction against all internal databases.

This route **does not** require authentication.

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