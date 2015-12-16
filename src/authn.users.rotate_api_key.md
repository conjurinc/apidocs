## Rotate API Key [/api/authn/users/api_key]

### Rotate the API key [PUT]

This method replaces the API key of an authn user with a new, securely random 
API key. The new API key is returned as the response body.

This request must be authenticated by Basic authentication using the existing 
API key or password of the user. A Conjur access token cannot be used to rotate
the API key.

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
