## Create [/api/host_factories/{?id,roleid,layers%5B%5D,cidr,ownerid}]

### Create a new host factory [POST]

Each Host Factory *acts as* a distinct Conjur role, which is specified when the host factory is created. 
All Hosts created by the Host Factory will be owned by this designated role.

If you don't provide an `id`, one will be randomly generated.

If you don't provide an `ownerid`, your user will be the owner of the Host Factory.
This means that no one else will be able to see your Host Factory.


**Permissions required**:

* The role specified by `roleid` must have adminship on the layer(s) specified by `layer`.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|201|Host factory created successfully|
|403|Permission denied|
|422|A host factory with that ID already exists|

+ Parameters
    + id: redis/default (string, optional) - ID of the host factory, query-escaped
    + roleid: cucumber:group:security_admin (string) - Fully qualified ID of a Conjur role that the host factory will act as, query-escaped
    + ownerid: cucumber:group:security_admin (string, optional) - Fully qualified ID of a Conjur role that will own the new host factory, query-escaped
    + layers%5B%5D: redis (string) - ID of the layer the host-factory can enroll hosts for, query-escaped. Can be specified multiple times.
    + cidr: 192.0.2.0 (string array, optional) - CIDR list to restrict hosts to the addresses specified.

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 201 (application/json)

    ```
    {
      "id": "redis/default",
      "layers": [
        "redis"
      ],
      "roleid": "cucumber:group:security_admin",
      "resourceid": "cucumber:host_factory:redis/default",
      "tokens": [
        {
          "cidr":["192.0.2.0"]
        }
      ]
    }
    ```
