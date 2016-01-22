## Set Expiration [/api/variables/{id}/expiration{?duration}]

### Set an expiration timestamp for a variable [POST]

:[min_version](partials/min_version_4.6.md)

You can set an expiration time for variables in Conjur.
After a variable expires, attempts to retrieve its value will fail.
Variable expiration will generate an audit event.

When a variable is set to expire, it will be marked with an annotation named
`expiration/timestamp`. The value of this annotation will be an ISO8601 UTC timestamp.

`duration` is specified in [ISO8601 duration format](https://en.wikipedia.org/wiki/ISO_8601#Durations).
<br>
For example, "P3Y6M4DT12H30M5S" represents a duration of "three years, six months, four days, twelve hours, thirty minutes, and five seconds".

If `duration` is not provided, or if the length of `duration` is zero (`P0Y`),
the variable will expire immediately.

[read more on expiration](https://developer.conjur.net/tutorials/secrets/expiring-secrets.html)

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Expiration set successfully|
|400|Specified duration is less than one second|
|403|Authenticated user does not have `update` permission on variable|

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable, query-escaped
    + duration: P3Y (string, optional) - ISO8601 duration specifying how far in the future to set the expiration

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    {
      "id": "dev/mongo/password",
      "resource_identifier": "cucumber:variable:dev/mongo/password",
      "expiration/timestamp": "2019-01-22T20:03:26Z"
    }
    ```
