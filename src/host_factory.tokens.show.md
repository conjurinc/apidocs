## Show Token [/api/host_factories/tokens/{id}/]

### Retrieve a host factory token's metadata [GET]

This route returns information about a host factory token, including its expiration timestamps, the layers to which it
is tied, as well as any CIDR restrictions that have been placed on it.

**Permission required**: `read` privilege on the host factory.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Token metadata returned|
|403|Permission denied|
|404|Host factory token not found|

+ Parameters
    + id: y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w (string) - ID of the token

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "token": "y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w",
      "expiration": "2015-11-13T20:38:51Z",
      "cidr": [
        "192.168.0.0/16"
      ],
      "host_factory": {
        "id": "redis_factory",
        "layers": [
          "redis"
        ],
        "roleid": "cucumber:group:ops",
        "resourceid": "cucumber:host_factory:redis_factory"
      }
    }
    ```
