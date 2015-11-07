## Update Password [/api/authn/users/password]

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

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

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
    :[conjur_auth_header_table](partials/conjur_auth_header_code.md)
    
    + Body
    
        ```
        password
        ```

+ Response 204
