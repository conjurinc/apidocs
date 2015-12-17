## Rotate API Key

Replaces the API key of an authn user with a new, securely random 
API key. The new API key is returned as the response body.

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Rotate your own API key [PUT /api/authn/users/api_key]

**Permissions required**:

Any authenticated identity can rotate its own API key, providing it's coming from a valid IP address.
Basic authorization (username plus password or API key) must be provided.

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

+ Request
    + Headers
    
        ```
        Authorization: Basic YWRtaW46cGFzc3dvcmQ=
        ```
        
+ Response 200 (text/html; charset=utf-8)

    ```
    14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc
    ```

### Rotate another user's API key [PUT /api/authn/users/api_key{?id}]

**Permissions required**: `update` privilege on the user.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|The response body is the API key|
|401|Not authenticated|
|403|Permission denied|

---

+ Parameters
    + id: alice (string, optional) - Id of the user to rotate.

+ Request
    :[conjur_auth_header_table](partials/conjur_auth_header_code.md)

+ Response 200 (text/plain)

    ```
    14m9cf91wfsesv1kkhevg12cdywm2wvqy6s8sk53z1ngtazp1t9tykc
    ```
