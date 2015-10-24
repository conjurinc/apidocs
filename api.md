FORMAT: 1A

# Conjur API

TODO description

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

            Authorization: Basic ZHVzdGluOm5hdStpbHVzMQ==

+ Response 200

    ```
    # The response body is the API key.
    1dsvap135aqvnv3z1bpwdkh92052rf9csv20510ne2gqnssc363g69y
    ```

+ Response 400

    ```
    # The credentials were not accepted.
    ```

## Authenticate [/api/authn/{login}/authenticate]

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

## Get members [/api/authz/{account}/roles/{role_kind}/{role_id}?members]

### Lists the roles that have been the recipient of a role grant [GET]

The creator of the role is always a role member and role administrator.

If role "A" is created by user "U" and then granted to roles "B" and "C",
then the members of role "A" are [ "U", "B", "C" ].

Role members are not expanded transitively.
Only roles which have been explicitly granted the role in question are listed.

**Permission Required**: Admin option on the role


+ Parameters
    + account: demo (string) - organization account name
    + role_kind: group (string) - kind of the role, for example 'group' or 'layer'
    + role_id: v1/ops (string) - ID of the role

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

## Grant to / Revoke from [/api/authz/{account}/roles/{role_a}/{role_id}?members&member={role_b}]

### Grant a role to another role [PUT]

All of this role's privileges are thereby granted to the new role.

When granted with `admin_option`, the grantee (given-to) role can grant the grantor (given-by) role to others.

`admin_option` is passed in the request body.

**Permission Required**: Admin option on the role


+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Request

    ```
    {admin_option: true}
    ```

+ Response 200 (text/plain)

    ```
    Role granted
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Role does not exist
    ```

### Revoke a granted role [DELETE]

Inverse of `role#grant_to`.

**Permission Required**: Admin option on the role


+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Response 200 (text/plain)

    ```
    Role revoked
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Role does not exist
    ```

## Group Variable

## Create [/api/variables]

### Create a new variable [PUT]

This is a 'secret' in Conjur and can be any value.

A variable can be created with or without an initial value.
If you don't give the variable an `id` one will be randomly generated.

The body is a JSON object containing:

```
id          - Name of the variable, optional
ownerid     - Owner of the variable
mime_type   - Media type of the variable
kind        - Purpose of the variable, optional
value       - Value of the variable, optional
```

+ Request

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

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 409

    ```
    # Variable with that name already exists
    ```

## Value [/api/variables/{id}/value?version={version}]

### Retrieve the value of a variable [GET]

By default this returns the latest version of a variable, but you can retrieve any earlier version as well.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable
    + version (string, optional) - Version of the variable to retrieve

+ Response 200 (text/plain)

    ```
    p89b12ep12puib
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Variable not found
    ```

## Values Add [/api/variables/{id}/values]

### Add a value to a variable [POST]

Variable ids must be escaped in the url, e.g., `'/' -> '%2F'`.

The body is a JSON object containing:

```
value       - Value of the variable
```

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable


+ Request

    ```
    {
        "value": "np89daed89p"
    }
    ```

+ Response 201 (text/plain)

    ```
    Value added
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Variable not found
    ```

+ Response 422

    ```
    # Value malformed or missing
    ```

## Group Utilities

## Health [/health]

### Perform a health check on the server [GET]

This method attempts an internal HTTP or TCP connection to each Conjur service.
It also attempts a simple transaction against all internal databases.

If all these tests are successful, the response is `HTTP 200`. Otherwise it's `HTTP 502`.

The response body is JSON that can be examined for additional details.

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
