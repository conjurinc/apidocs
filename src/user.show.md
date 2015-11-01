## Show [GET /api/users/{login}]

Retrieve a user's record.

The response for this method is similar to that from create,
but it **does not contain the user's API key**.

The login parameter must be url encoded.

**Permission Required**

`read` permission on the user's resource.

---

**Response**

|Code|Description|
|----|-----------|
|200|The response body contains the user's record|
|403|You don't have permission to view the record|
|404|No user exists with the given login name|

+ Parameters
    + login: alice (string) - The user's login

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
