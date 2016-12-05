## Policy [/api/ldap-sync/policy]

### Synchronize users and groups from LDAP to Conjur [GET]

:[min_version](partials/min_version_4.7.md)

Show the policy that will synchronize users and groups from an Active Directory or POSIX LDAP server (e.g. OpenLDAP) into Conjur.
The synchronization does not include passwords. To delegate Conjur login
to LDAP, use the [LDAP Authenticator](https://developer.conjur.net/server_setup/tools/authn_ldap.html).

LDAP-Sync configuration settings are stored in *profiles*. Use the `config_name` parameter to specify
which profile to use for the sync. The default profile name, used by the UI and `conjur ldap-sync policy show` command, is `default`.

The `Accept` HTTP request header must be provided, and must be `text/event-stream`. 

The server will emit [Server Sent Events](https://www.w3.org/TR/eventsource/) while generating the policy. The body of each event is a JSON object. The server returns a status of `200` if it was able to generate events, even if it was unsuccessful in generating the policy.

Event bodies with the key `"log"` are messages produced while generating a policy. The final event will have the key `"ok"`, with a value that indicates whether the policy generation succeeded. If `"ok"` is `true`, the object will also have the key `"policy"`. The value of this member will be the YAML policy. If `"ok"` is `false`, the object will have the key `"error"`. The value of this member will be another JSON object, with a member called `"message"` that contains the error message.

> Note that in the example, the JSON objects have had newlines added for readability. The server will send all events as a single line.

**Permission Required**: `execute` privilege on resource `webservice:conjur/ldap-sync`


---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)
|Accept|Requested HTTP response content type|text/event-stream|

**Response**

|Code|Description|
|----|-----------|
|200|Events were generated successfully|
|403|Authenticated user does not have `execute` permission on the webservice|
|406|Invalid Accept header value|
|422|Config malformed or missing|

+ Parameters
    + config_name: default (string) - Name of the profile to use to generate the policy


+ Response 200 (text/event-stream)

    ```
        ...
    data: {"log":
            {
               "timestamp":"2016-12-05T20:43:10.591+00:00",
               "severity":"info",
               "message":"Connecting to upstream LDAP..."
            }
          }
        ...
    data: {"ok": true, "policy": 
     "---
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
         id: Domain Users"}
    ```
