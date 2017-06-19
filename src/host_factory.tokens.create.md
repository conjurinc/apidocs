## Create Token [/api/host_factories/{id}/tokens{?expiration,count,cidr%5B%5D}]

### Create a new host factory token [POST]

By passing a host factory token to a new host, it can enroll itself into a specified layer. 
This route creates those tokens.

Host factory tokens expire after a certain amount of time. By default, this is one hour. Use the
`expiration` parameter to set your own expiration timestamp. The timestamp is in 
[ISO8601 format](http://ruby-doc.org/stdlib-2.1.1/libdoc/time/rdoc/Time.html#class-Time-label-Converting+to+a+String)
and must be URL-encoded.

Use of host factory tokens can be restricted to particular IP addresses [using one or more CIDRs](https://developer.conjur.net/reference/services/host_factory/#cidr-restricted-tokens).

*Example*

`2015-11-16T14:36:57-05:00` -> `2015-11-16T14%3A36%3A57-05%3A00`

Generate multiple tokens at once with the `count` parameter. By default, one token is created.

**Permission required**: `execute` privilege on the host factory.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of created tokens is returned|
|403|Permission denied|
|404|Host factory not found|

+ Parameters
    + id: redis/default (string) - ID of the host factory, query-escaped
    + expiration: `2017-12-16T14:36:57-05:00` (string, optional) - Expiration timestamp (ISO8601), query-escaped
    + count: 2 (number, optional) - Number of tokens to create
    + cidr%5B%5D: 192.168.0.0/16 (string) - addresses to restrict tokens to

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "token": "3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q3219717wv6fksget9v",
        "expiration": "2015-11-13T20:17:00Z"
        "cidr": [
          "192.168.0.0/16"
        ]
      },
      {
        "token": "34m4qev29dm73vk4pccp2e53t7x3ffy7e81d9hn0m3b9103j1h09fjn",
        "expiration": "2015-11-13T20:17:00Z"
        "cidr": [
          "192.168.0.0/16"
        ]
      }
    ]
    ```
