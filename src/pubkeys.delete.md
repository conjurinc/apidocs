## Delete [/api/pubkeys/{login}/{key_name}]

### Delete a key for a user [DELETE]

Removes a public key for a specified user.
`key_name` is the comment placed at the end of the public key, usually
an email address.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

The public key to add should be the entire request body.

**Response**

|Code|Description|
|----|-----------|
|204|Public key deleted for user|
|403|Permission denied|
|404|User or key not found|

+ Parameters
    + login: alice (string) - The user's login name
    + key_name: alice@bigcorp.com (string) - Comment at end of SSH key to remove

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
