## Active Rotators [/api/rotation/rotators]

:[min_version](partials/min_version_4.7.md)

### List active variable rotators [GET]

Lists enabled and active secrets rotators running in Conjur.

The `name` field in the response maps to the value of the
`rotation/rotator` annotation placed on variables to be rotated.

---

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of active rotators|

+ Response 200 (application/json)

    ```
    [
        {
            "name":"pg-rotator",
            "type":"Rotation::Target::Postgresql::Password",
        },
        {
            "name":"aws-rotator",
            "type":"Rotation::Target::AWS::SecretKey",
        }
    ]
    ```
