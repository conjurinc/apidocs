## Create [/api/hosts/]

### Create a new host [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the host.
This means that no one else will be able to see your host.

The API key for the host is returned in the response. This is the **only** time you
will see the API key, so save it somewhere if you want to be able to log in as the host
identity on the command line.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|id|Name of the host|no|`String`|"redis001"|
|ownerid|Fully qualified ID of a Conjur role that will own the new host|no|`String`|"demo:group:ops"|

**Response**

|Code|Description|
|----|-----------|
|201|Host created successfully|
|403|Permission denied|
|409|A host with that name already exists|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        {
            "id": "redis001",
            "ownerid": "demo:group:ops"
        }
        ```

+ Response 201 (application/json)

    ```
    {
      "id": "redis001",
      "userid": "demo",
      "created_at": "2015-11-03T21:34:47Z",
      "ownerid": "demo:group:ops",
      "roleid": "demo:host:redis001",
      "resource_identifier": "demo:host:redis001",
      "api_key": "3sqgnzs2yqtjgf3hx6fw6cdh8012hb6ehy1wh406eeg8ktj27jgabd"
    }
    ```
