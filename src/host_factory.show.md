## Show [/api/host_factories/{id}]

### Retrieve a host factory's record [GET]

This route returns information about a host factory, including its attached hosts.

This response includes the host factory's deputy API key and all valid tokens.

Host factory IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

**Permission required**: `read` privilege on the host factory.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Host factory record is returned|
|403|Permission denied|
|404|Host factory not found|

+ Parameters
    + id: redis (string) - ID of the host factory, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
        "id":"redis",
        "layers":[],
        "roleid":"cucumber:group:security_admin",
        "resourceid":"cucumber:host_factory:redis",
        "tokens":[
            {
              "token": "30vf6aa3b6x326sdnwj93cx5rzd3dwmhva3828m8x32xsveh5qb4x5",
              "expiration": "2015-11-13T18:42:02Z",
              "cidr":["172.17.0.0/16"]
            }
        ]
    }
    ```
