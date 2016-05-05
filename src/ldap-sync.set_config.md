## Set Config [/api/ldap-sync/config/{name}]

### Set ldap-sync configuration [PUT]

:[min_version](partials/min_version_4.7.md)

Store the ldap-sync configuration to be used by the `/api/ldap-sync/sync` route to synchronize LDAP users and groups into Conjur user and group records.

**Permission Required**: `update` privilege on the webservice:conjur/ldap-sync

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

|Field|Description|Required|Type|Example|
|-----|-----------|----|--------|-------|
|config|New configuration to set for ldap-sync|yes|`json`|""|
|port|port of the LDAP server|yes|`String`|"389"|
|host|hostname of the LDAP server|yes|`String`|"ldap.mycorp.com"|
|base_dn|the base DN of the LDAP server|yes|`String`|"CN=Users,DC=MyCorp,DC=local"|
|bind_dn|the account name to authenticate to the LDAP server|yes|`String`|"MYCORP\\Administrator"|
|bind_password|the password for the account to authenticate to the LDAP server|yes|`String`|"(objectClass=user)"|
|user_filter|the user filter|yes|`String`|"(objectClass=user)"|
|group_filter|the group filter|yes|`String`|"(objectClass=group)"|
|user_attribute_mapping|attributes from LDAP to map to Conjur users|yes|`json`|""|
|name|LDAP user attribute to map to the Conjur user name|yes|`String`|"sAMAccountName"|
|uid|LDAP user attribute to map to the Conjur user uid|yes|`String`|"uidNumber"|
|group_attribute_mapping|attributes from LDAP to map to map to Conjur users|yes|`json`|""|
|name|LDAP group attribute to map to the Conjur group name|yes|`String`|"cn"|
|uid|LDAP group attribute to map to the Conjur group gid|yes|`String`|"gidNumber"|

**Response**

|Code|Description|
|----|-----------|
|200|Config set|
|403|Permission denied|
|422|Config malformed or missing|

+ Parameters
    + name: default (string) - optional configuration name - 'default' is the default name

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

    + Body

        ```
        "config": {
                "port": 389,
                "host": "ldap.mycorp.com",
                "base_dn": "CN=Users,DC=MyCorp,DC=local",
                "bind_dn": "MYCORP\\Administrator",
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
        ```

+ Response 200 (application/json; charset=utf-8)

    ```
    {
       "ok": true
    }
    ```
