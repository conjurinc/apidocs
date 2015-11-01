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
