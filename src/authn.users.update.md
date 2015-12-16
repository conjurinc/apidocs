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
