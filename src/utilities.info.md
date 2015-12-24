## Server Info [/info]

:[conjur_auth_header_table](partials/min_version_4.6.md)

### Display information about server configuration [GET]

This method shows information about the configuration state of the server. In particular,
it provides a list of the installed services, along with the specific package name and version
of each one. It also provides the server role (master, follower, standby) as a top-level JSON field,
and it provides the contents of the server `configuration` attributes. 

This method **does not** require authentication.

---

**Response**

|Code|Description|
|----|-----------|
|200|Ok|

+ Response 200

    ```
    {
      "services": {
        "evoke": {
          "desired": "i",
          "status": "i",
          "err": null,
          "name": "conjur-evoke",
          "version": "4.6.0-37-g964b113",
          "arch": "amd64"
        }
      },
      "role": "master",
      "configuration": {
        "conjur": {
          "role": "master",
          "account": "cucumber",
          "hostname": "cuke-master",
          "master_altnames": [
            "cuke-master.docker",
            "conjur",
            "localhost"
          ],
          "slave_altnames": [
            "cuke-follower.docker",
            "conjur",
            "localhost"
          ]
        }
      }
    }
    ```
