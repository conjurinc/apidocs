## Sync [/api/ldap-sync/sync]

### Synchronize users and groups from LDAP to Conjur [POST]

:[min_version](partials/min_version_4.7.md)

Synchronize users and groups from an Active Directory or POSIX LDAP server (e.g. OpenLDAP) into Conjur.
The synchronization is one-way, from LDAP to Conjur, and does not include passwords. To delegate Conjur login
to LDAP, use the [LDAP Authenticator](https://developer.conjur.net/server_setup/tools/authn_ldap.html).

LDAP-Sync configuration settings are stored in *profiles*. Use the `config_name` parameter to specify
which profile to use for the sync. The default profile name, used by the UI and `conjur ldap-sync now` command, is `default`.

When `dry_run` is `true`, the result will contain a listing of the actions that would be performed, but no changes are actually made to Conjur. When `dry_run` is `false`, the LDAP users and groups are synchronized from LDAP to Conjur. The
default value of this parameter is `false` (perform the sync).

The `Content-Type` HTTP request header must be provided, and may be either `application/json` or `multipart/form-data`. Examples below use JSON request bodies, but form data is also accepted.

The `Accept` HTTP request header must be provided, and may be either `application/json` or `text/yaml`. The JSON response contains the event log from running synch operation, along with a list of text strings describing the actions
which were (or would be) performed. The YAML response contains the Conjur Policy YAML to perform the sync. This YAML is valid input for the command-line command `conjur policy load`. `text/yaml` format is useful in conjunction with the `dry_run` parameter, in order to inspect the synchronization changes before they are performed. 

**Permission Required**: `execute` privilege on resource `webservice:conjur/ldap-sync`

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept|Requested HTTP response content type|application/json|
|Content-Type|Type of data in request body|application/json|

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
          "user 'stevef'",
          "group 'Domain Admins'",
          "group 'Domain Users'",
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

+ Response 200 (text/yaml;charset=utf-8)

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
