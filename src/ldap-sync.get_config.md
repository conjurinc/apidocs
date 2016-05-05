## Get Config [/api/ldap-sync/config/{name}]

### Get ldap-sync configuration [GET]

Retrieves the configuration stored for the ldap-sync service. The password is not included as part of the retrieved configuration.

**Permission Required**: `read` permission on webservice:conjur/ldap-sync.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|The response body contains the ldap-sync configuration|
|403|You don't have permission to view the configuration|
|404|No configuration with that name exists|

+ Parameters
    + name: default (string) - optional configuration name - 'default' is the default name

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    {
      "ok": true,
      "config": {
        "port": 389,
        "host": "ldap.mycorp.com",
        "base_dn": "CN=Users,DC=MyCorp,DC=local",
        "bind_dn": "CONJUR\\Administrator",
        "user_filter": "(objectClass=user)",
        "group_filter": "(objectClass=group)",
        "user_attribute_mapping": {
          "name": "sAMAccountName",
          "uid": "uidNumber"
        },
        "group_attribute_mapping": {
          "name": "cn",
          "gid": "gidNumber"
        }
      }
    }
    ```
