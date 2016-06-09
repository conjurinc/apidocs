## Sync [/api/ldap-sync/sync]

### Synchronize users and groups from LDAP to Conjur [POST]

:[min_version](partials/min_version_4.7.md)

Synchronize users and groups from Active Directory or an LDAP server into Conjur.

Use the `config_name` parameter for the configuration profile name. The profile name tells LDAP-Sync the full identifiers for the LDAP-Sync configuration resource (`configuration:conjur/ldap-sync/:config_name`) and password variable (`conjur/ldap-sync/bind-password/:config_name`). The default name used by the UI and `conjur ldap-sync now` command is `default`.

When `dry_run` is `true`, the result will contain a text log of the actions that would occur but no changes are made to Conjur. Set to `false` to synchronize the users and groups from LDAP to Conjur. Defaults to `false` if not provided.

The `Content-Type` HTTP header must be provided and contain either `application/json` or `multipart/form-data`. Examples below use JSON request bodies, but form data is also accepted.

The `Accept` HTTP header must be provided and contain either `application/json` or `text/yaml`. The JSON response contains the event log from running the request. The YAML response contains only the generated Conjur Policy YAML useful for loading with `conjur policy load`. It is recommended to only use `text/yaml` in conjunction with a dry-run as the response lacks extended errors information.


**Permission Required**: `update` privilege on webservice:conjur/ldap-sync

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept|Requested HTTP response content type|application/json|

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|config_name|Name of the configuration profile|yes|`String`|"default"|
|dry_run|Flag to enable dry-run mode (default: "false")|no|`Boolean`|"false"|

**Response**

|Code|Description|
|----|-----------|
|200|Sync ran successfully|
|403|Authenticated user does not have `update` permission on the webservice|
|406|Invalid Accept header value|
|422|Config malformed or missing|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)
    Accept: application/json

    + Body

        ```
        {
          "config_name": "default",
          "dry_run": false
        }
        ```

+ Response 200 (application/json)

    ```
    {
      "ok": true,
      "result": {
        "actions": [
          "user 'paulf'",
          "user 'mikeb'",
          "user 'stevef'"
          "group 'Domain Admins'",
          "group 'Domain Users'"
          "Grant group 'Domain Admins' to user 'paulf', group 'conjur/ldap-sync' exclusively",
          "Grant group 'Domain Users' to user 'mikeb', user 'stevef', group 'conjur/ldap-sync' exclusively"
        ]
      },
      "events": [
        {
            "timestamp": "2016-06-08T20:45:50.485+00:00",
            "severity": "info",
            "message": "Connecting to upstream LDAP..."
        },
        {
            "timestamp": "2016-06-08T20:45:50.487+00:00",
            "severity": "info",
            "message": "Connected successfully!"
        },
        {
            "timestamp": "2016-06-08T20:45:50.665+00:00",
            "severity": "info",
            "message": "Generating policy"
        }
      ]
   }
    ```

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)
    Accept: text/yaml

    + Body

        ```
        {
          "config_name": "default",
          "dry_run": true
        }
        ```

+ Response 200 (text/yaml)

    ```
     ---
     - !user
       annotations:
         ldap-sync/source: ldap.example.com:389
         ldap-sync/upstream-dn: cn=paulf,dc=example,dc=org
       id: paulf
     - !user
       annotations:
         ldap-sync/source: ldap.example.com:389
         ldap-sync/upstream-dn: cn=mikeb,dc=example,dc=org
       id: mikeb
     - !user
       annotations:
         ldap-sync/source: ldap.example.com:389
         ldap-sync/upstream-dn: cn=stevef,dc=example,dc=org
       id: stevef
     - !group
       annotations:
         ldap-sync/source: ldap.example.com:389
         ldap-sync/upstream-dn: cn=Domain Admins,dc=example,dc=org
       id: Domain Admins
     - !group
       annotations:
         ldap-sync/source: ldap.example.com:389
         ldap-sync/upstream-dn: cn=Domain Users,dc=example,dc=org
       id: Domain Users
     - !grant
       member:
       - !member
         admin: false
         role: !user
           id: paulf
       - !member
         admin: true
         role: !group
           id: conjur/ldap-sync
       replace: true
       role: !group
         id: Domain Admins
     - !grant
       member:
       - !member
         admin: false
         role: !user
           id: mikeb
       - !member
         admin: false
         role: !user
           id: stevef
       - !member
         admin: true
         role: !group
           id: conjur/ldap-sync
       replace: true
       role: !group
         id: Domain Users
    ```
