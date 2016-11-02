## Health [/health]

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Perform a health check on the server [GET]

This method attempts an internal HTTP or TCP connection to each Conjur service.
It also attempts a simple transaction against all internal databases.

Free space and inodes are returned for both the `main` and `archive` databases.

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
