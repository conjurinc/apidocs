## Update [/api/authn/users]

This method updates attributes of a User.

The principle use of this method is to change the IP restriction (IP address(es) or CIDR(s))
of a user. This method can be applied to any Conjur identity, but is most often used on
hosts.

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Update your own attributes [PUT /api/authn/users{?cidr}]

**Permissions required**:

Any authenticated identity can update its own record, providing it's coming from a valid IP address.
Basic authorization (username plus password or API key) must be provided.

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|HTTP Basic Auth|Basic Y2hhcmxlczo5cDhuZnNkYWZicA==|

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the JSON of the User record|
|401|The Basic auth credentials were not accepted|

+ Parameters
    + cidr: 192.0.2.0 (string array, optional) - New CIDR list for the user.

+ Request
    + Headers
    
        ```
        Authorization: Basic Y2hhcmxlczo5cDhuZnNkYWZicA==
        ```
        
+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "login": "charles",
        "cidr": ["192.0.2.0"]
    }
    ```

### Update another user's attributes [PUT /api/authn/users{?id,cidr}]

**Permissions required**:

`update` privilege on the user's resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the JSON of the User record|
|401|The request was not authenticated, or the privilege is insufficient|

+ Parameters
    + id: charles (string) - Id of the user to update.
    + cidr: 192.0.2.0 (string array, optional) - New CIDR list for the user.

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    {
        "login": "charles",
        "cidr": ["192.0.2.0"]
    }
    ```
