## Health [/health]

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Perform a health check on the server [GET]

This method attempts an internal HTTP or TCP connection to each Conjur service.
It also attempts a simple transaction against all internal databases.

In addition, the position of the database transaction log is provided for both
master and followers. On the master, the JSON field `database/replication_status/pg_current_xlog_location_bytes`
shows the byte position of the last committed transaction. On followers, the JSON field
`database/replication_status/pg_last_xlog_replay_location_bytes` shows the byte position of the last
fully replicated transaction. The difference between these two numbers is the replication lag 
between the follower and the master.

This route **does not** require authentication.

---

**Response**

|Code|Description|
|----|-----------|
|200|Server is healthy|
|502|Server is not healthy|

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

+ Response 502

    ```
    {
      "services":
        {
          "host-factory":"ok","core":"ok","pubkeys":"ok","audit":"error",
          "authz":"ok","authn":"ok","ldap":"ok","ok":false
        },
      "database":{"ok":true,"connect":{"main":"ok"}},
      "ok":false
    }
    ```
