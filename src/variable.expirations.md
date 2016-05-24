## List Expirations [/api/variables/expirations{?duration}]

### List variables with expirations [GET]

:[min_version](partials/min_version_4.6.md)

Returns all variables visible to the current user that have an expiration applied.
`duration` is specified in [ISO8601 duration format](https://en.wikipedia.org/wiki/ISO_8601#Durations).
If `duration` is set, the expiration interval (measured from the current time) is provided,
limits the variables to only those that expire within the interval.
In the example, we're searching for variables expiring within the next 3 years.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|Variable expirations are returned|
|400|Malformed duration|

+ Parameters
    + duration: P3Y (string, optional) - ISO8601 duration for limiting results

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:variable:dev/mongo/password",
        "owner": "cucumber:group:ops",
        "permissions": [],
        "annotations": [
          {
            "resource_id": 20,
            "name": "expiration/timestamp",
            "value": "2019-01-22T20:18:27Z",
            "created_at": "2016-01-22T19:53:40.172+00:00",
            "updated_at": "2016-01-22T20:18:27.349+00:00"
          },
          {
            "resource_id": 20,
            "name": "expiration/audited",
            "value": "false",
            "created_at": "2016-01-22T19:53:40.183+00:00",
            "updated_at": "2016-01-22T20:18:27.360+00:00"
          }
        ]
      }
    ]
    ```
