## Health [/health]

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Perform a health check on the server [GET]

This method provides information about the health and status of the internal server components.
It also "rolls up" this information into a top-level `true / false` statement about the health
of the server, reported both as a JSON field and as HTTP status.

**Services**

The first block of information reports the status of each Conjur service. The health check 
attempts an internal HTTP or TCP connection to each Conjur service and reports `ok` if the 
services is up, and otherwise an error message string. If any service is not `ok`, then the overall
server health is `false`.

**Database**

The second block of information reports on the database health. Details are avaliable on each
database; if any database is unhealthy, then the overall service health is `false`.

Each Conjur server runs a database called `main`. On the master, this is where the "write"
transactions are written. On the follower and standby, the `main` database is a read-only replica from 
the master. 

Masters and standbys run a second database called `archive`, which stores a rolling window of audit data
collected from across the HA cluster. 

Followers run a second database called `audit`, which is a local read-write store of audit
events performed on the follower. Audit records are continuously pushed to the master; if the master is 
temporarily unavailable, the audit records will accumulate on the follower until the master is available again.

`main`, `archive`, and `audit` each have their own sections in the health check. For each database, the health
check indicates whether the database service is running and accepting connections. 

On the master, the health check indicates the replication status of the followers and standbys. The JSON field `database/replication_status/pg_current_xlog_location_bytes` shows the byte position of the last committed transaction.

On the followers and standby, the health check indicates the replication status of the `main` cluster. The JSON field
`database/replication_status/pg_last_xlog_replay_location_bytes` shows the byte position of the last fully replicated
transaction. The difference between `pg_current_xlog_location_bytes` and `pg_last_xlog_replay_location_bytes` 
is the replication lag between the follower and the master.

On the followers, the health check also indicates the number of messages which are queued in the `audit` database and waiting to be pushed to the master.

Since Conjur 4.8, free space and inodes are also checked on all databases. If there is no free space or no inodes
available to a database, then the server is unhealthy.

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

