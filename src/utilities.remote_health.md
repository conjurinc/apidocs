## Remote Health [/remote_health]

:[conjur_auth_header_table](partials/min_version_4.6.md)

To support a High Availablity (HA) configuration, Conjur master, standby, and follower servers support 
a Remote Health check to allow any Conjur server to check the health of another Conjur server to ensure
servers are up and services are running properly. Specifically this is used to check the health and
availablity of the master server from the standby and follower servers. Refer to the Health API for the
response information returned by the remote health API.

Request: GET https://conjur.myorg.com/remote_health/hostname
Parameter: hostname - The hostname of the master, standby, or follower to get the health of

This route **does not** require authentication.

---

**Response**

|Code|Description|
|----|-----------|
|200|Remote Server is healthy|
|502|Remote Server is not healthy|
