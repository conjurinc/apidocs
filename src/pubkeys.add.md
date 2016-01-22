## Add [/api/pubkeys/{login}]

### Add a key for a user [POST]

Adds a new public key for an existing user.
Multiple keys can be uploaded per user.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

The public key to add should be the entire request body.

**Response**

|Code|Description|
|----|-----------|
|200|Public key added for user|
|403|Permission denied|
|500|Public key malformed|

+ Parameters
    + login: alice (string) - The user's login name

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFDhYPIMHAqlQghhdmEa98UrfK9HBX8AaW4aSj5sVwigy7wFMs9yjPfK/mGOV5T5g5TuSe8EQfRfX4Mp6yv40ta4ETAJti7cjoh8KwkxnKPUQmhkgWmTJRfwUwYq12yzmqFp7nZ6JNfng39TvD+L6McpFgC+O7O3IeGBHSz8PB6QE7TbvICSbOPU43d1MQpsvtbgIAM6rTC44JAPor9YoHSne1dsaNCsu4xFUXROJpD2V6eSRHw8tpN6vzxgym5ZDRMCWPhhN82xmEwPFt6qi6nN5ky0qTzPtJhsTu0dPjyJbgLfyFOu/iPTPHi9oWXuMJpwry9cMTG/wcAR8JG5lJ alice@bigcorp.com
        ```

+ Response 200

    ```
    {
      "id":"9e1rkk",
      "userid":"host/pubkeys-1.0/host/cuke-master/services/pubkeys",
      "mime_type":"text/plain",
      "kind":"authorized_key",
      "ownerid":"cucumber:layer:pubkeys-1.0/public-keys",
      "resource_identifier":"cucumber:variable:9e1rkk",
      "version_count":1
    }
    ```
