## Remote Health [/remote_health/{hostname}]

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Perform a health check on a remote Conjur server [GET]

To support a High Availablity (HA) configuration, Conjur master, standby, and follower servers
support a Remote Health check to allow any Conjur server to check the health of another Conjur
server to ensure servers are up and services are running properly.
Specifically this is used to check the health and availablity of the master server from the
standby and follower servers.
The response is the same format as the [Health API route](/#reference/utilities/health).

This route **does not** require authentication.

---

**Response**

|Code|Description|
|----|-----------|
|200|Remote Server is healthy|
|502|Remote Server is not healthy|

+ Parameters
    + hostname: `conjur-master01.myorg.com` (string) - The hostname of a master, standby, or follower to check health on

+ Response 200

    ```
    {
      "services": {
        "audit": "ok",
        "authz": "ok",
        "rotation": "ok",
        "authn": "ok",
        "core": "ok",
        "ldap-sync": "ok",
        "pubkeys": "ok",
        "expiration": "ok",
        "ldap": "ok",
        "host-factory": "ok",
        "ok": true
      },
      "database": {
        "ok": true,
        "connect": {
          "main": "ok",
          "archive": "ok"
        },
        "free_space": {
          "main": {
            "inodes": 2437636,
            "kbytes": 31024512
          },
          "archive": {
            "inodes": 2437636,
            "kbytes": 31024512
          }
        },
        "replication_status": {
          "pg_current_xlog_location": "0/20744A0",
          "pg_current_xlog_location_bytes": 34030752
        },
        "archive_replication_status": {
          "pg_current_xlog_location": "0/1962EF8",
          "pg_current_xlog_location_bytes": 26619640
        }
      },
      "ok": true
    }
    ```
