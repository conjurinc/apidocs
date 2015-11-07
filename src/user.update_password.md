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
