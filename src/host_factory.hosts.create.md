## Create Host [/api/host_factories/hosts{?id}]

### Create a new host using a host factory token [POST]

To create a new host with a host factory token, you pass the token in the `Authorization` header, like so:

```
Authorization: Token token="<insert host factory token here>"
```

---

**Headers**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Host factory token|Token token="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v"|

**Response**

|Code|Description|
|----|-----------|
|201|JSON record of host created returned|
|403|Permission denied|
|422|Host with that ID already exists or token is invalid for the layer|

+ Parameters
    + id: redis002 (string) - ID of the host to create, query-escaped

+ Request
    + Headers
    
        ```
        Authorization: Token token="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v"
        ```

+ Response 201 (application/json; charset=utf-8)

    ```
    {
        "id":"redis002",
        "userid":"deputy/redis_factory",
        "created_at":"2015-11-13T22:57:14Z",
        "ownerid":"cucumber:group:ops",
        "roleid":"cucumber:host:redis002",
        "resource_identifier":"cucumber:host:redis002",
        "api_key":"14x82x72syhnnd1h8jj24zj1kqd2j09sjy3tddwxc35cmy5nx33ph7"
    }
    ```
