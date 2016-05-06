## Sync [/api/ldap-sync/sync]

### Synchronize users and groups from LDAP to Conjur [POST]

:[min_version](partials/min_version_4.7.md)

Synchronize users and groups from Active Directory or an LDAP server into Conjur.

This will load users and groups from the LDAP server based on the specified configuration name - `default` is the name of the default config and references the resource `configuration:conjur/ldap-sync/default`.

By setting the dry_run field to false, the users and groups will be loaded into Conjur and the results will be returned. If the dry_run field is true, only the result will be returned with the actions that would have taken place on a real sync.

**Permission Required**: `update` privilege on webservice:conjur/ldap-sync

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|config|Name of the configuration to use - 'default' should be used|yes|`String`|"default"|
|dry_run|dry run true to get sync results but not update Conjur, false to update Conjur|yes|`Boolean`|"false"|
|format|Return the format of actions as json or text - default is json|yes|`String`|"json"|

**Response**

|Code|Description|
|----|-----------|
|200|Sync ran successfully|
|403|Authenticated user does not have `update` permission on the webservice|
|422|Config malformed or missing|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
      "config": "default",
      "dry_run": false,
      "format": "json"
        ```

+ Response 200 (application/json)

    ```
    {
      "ok": true,
      "result": {
        "actions": [
          {
            "record": {
              "id": "paulf",
              "annotations": {
                "ldap-sync/upstream-dn": "CN=Paul,CN=Users,DC=mycorp,DC=local"
              },
              "account": "dev",
              "owner": {
                "kind": "group",
                "id": "conjur/ldap-sync",
                "account": "dev"
              }
            },
            "action": "create"
          },
          {
            "record": {
              "id": "mikeb",
              "annotations": {
                "ldap-sync/upstream-dn": "CN=Mike,CN=Users,DC=mycorp,DC=local"
              },
              "account": "dev",
              "owner": {
                "kind": "group",
                "id": "conjur/ldap-sync",
                "account": "dev"
              }
            },
            "action": "create"
          }
        ]
      }
    }
    ```
