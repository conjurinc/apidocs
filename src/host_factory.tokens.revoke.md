## Revoke Token [/api/host_factories/tokens/{id}]

### Revoke a host factory token [DELETE]

Host factory tokens are not automatically revoked when they expire. Revoke a token when you want to disallow
its use before its expiration timestamp.

When you revoke a token, hosts can no longer use it to enroll in a layer.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|204|Token revoked|
|403|Permission denied|
|404|Host factory token not found|

+ Parameters
    + id: y5c8pt2hvrpka1gq0w552xcxfy0ddp7w4gz1pgk3cdww2bsk0g8w (string) - ID of the token

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
