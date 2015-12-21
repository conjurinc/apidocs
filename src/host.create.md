## Create [/api/hosts/{?id,ownerid}]

### Create a new host [POST]

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the host.
This means that no one else will be able to see your host.

The API key for the host is returned in the response. This is the **only** time you
will see the API key, so save it somewhere if you want to be able to log in as the host
identity on the command line.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|201|Host created successfully|
|403|Permission denied|
|409|A host with that name already exists|

+ Parameters
    + id: redis001 (string, optional) - Name of the host, query-escaped
    + ownerid: cucumber:group:ops (string, optional) - Fully qualified ID of a Conjur role that will own the new host

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json; charset=utf-8)

    ```
    {
      "id": "redis001",
      "userid": "admin",
      "created_at": "2015-11-03T21:34:47Z",
      "ownerid": "cucumber:group:ops",
      "roleid": "cucumber:host:redis001",
      "resource_identifier": "cucumber:host:redis001",
      "api_key": "3sqgnzs2yqtjgf3hx6fw6cdh8012hb6ehy1wh406eeg8ktj27jgabd"
    }
    ```
