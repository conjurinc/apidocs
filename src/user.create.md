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

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

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
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)
    
    + Body

          ```
          {
              "login":"bob",
              "password":"supersecret",
              "ownerid":"cucumber:group:security_admin",
              "uidnumber":123456
          }
          ```

+ Response 201 (application/json; charset=utf-8)
    ```
    {
        "login":"bob",
        "userid":"admin",
        "ownerid":"cucumber:group:security_admin",
        "uidnumber":123456,
        "roleid":"cucumber:user:bob",
        "resource_identifier":"cucumber:user:bob",
        "api_key":"3c6vwnk3mdtks82k7f23sapp93t6p1nagcergrnqw91b12sxc21zkywy"
    }
    ```