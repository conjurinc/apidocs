## Sync [/api/ldap-sync/sync]

### Synchronize users and groups from LDAP to Conjur [POST]

:[min_version](partials/min_version_4.7.md)

Synchronize users and groups from Active Directory or an LDAP server into Conjur.

Use the `config_name` parameter for the configuration profile name. The profile name tells LDAP-Sync the full identifiers for the LDAP-Sync configuration resource (`configuration:conjur/ldap-sync/:config_name`) and password variable (`conjur/ldap-sync/bind-password/:config_name`). The default name used by the UI and `conjur ldap-sync now` command is `default`.

When `dry_run` is `true`, the result will contain a text log of the actions that would occur but no changes are made to Conjur. Set to `false` to synchronize the users and groups from LDAP to Conjur. Defaults to `false` if not provided.

The `Accept` HTTP header must be provided and contain either `application/json` or `application/yaml`. The JSON response contains the event log from running the request. The YAML response contains only the generated Conjur Policy YAML useful for loading with `conjur policy load`. It is recommended to only use `application/yaml` in conjunction with a dry-run as the response lacks extended errors information.


**Permission Required**: `update` privilege on webservice:conjur/ldap-sync

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept|Requested HTTP response content type|application/json|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|config_name|Name of the configuration profile|yes|`String`|"default"|
|dry_run|Flag to enable dry-run mode (default: "true")|no|`Boolean`|"false"|

**Response**

|Code|Description|
|----|-----------|
|200|Sync ran successfully|
|403|Authenticated user does not have `update` permission on the webservice|
|406|Invalid Accept header value|
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
