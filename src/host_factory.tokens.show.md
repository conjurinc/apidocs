## Show Token [/api/host_factories/tokens/{id}/]

### Retrieve a host factory token's metadata [GET]

This route returns information about a host factory token, including its expiration timestamps
and the layers to which it is tied.

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

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "token": "y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w",
      "expiration": "2015-11-13T20:38:51Z",
      "host_factory": {
        "id": "redis_factory",
        "layers": [
          "redis"
        ],
        "roleid": "conjur:group:ops",
        "resourceid": "conjur:host_factory:redis_factory"
      }
    }
    ```
