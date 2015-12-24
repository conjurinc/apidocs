## Server Info [/info]

### Display information about server configuration [GET]

This method shows information about the configuration state of the server.

It **does not** require authentication.

The response body is JSON that can be examined for additional details.

---

**Response**

|Code|Description|
|----|-----------|
|200|Ok|

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
