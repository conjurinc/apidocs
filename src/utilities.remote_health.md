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
    + hostname: `localhost` (string) - The hostname of a master, standby, or follower to check health on

+ Response 200

    ```
    {
      "services": {
        "host-factory": "ok",
        "authz": "ok",
        "pubkeys": "ok",
        "authn": "ok",
        "audit": "ok",
        "ldap": "ok",
        "core": "ok",
        "ok": true
      },
      "database": {
        "ok": true,
        "connect": {
          "main": "ok"
        },
        "replication_status": {
          "pg_current_xlog_location": "0/5174000",
          "pg_current_xlog_location_bytes": 85409792
        }
      },
      "ok": true
    }
    ```
