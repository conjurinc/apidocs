## Active Rotators [/api/rotation/rotators]

:[5.0](partials/min_version_5.0.md)

### List active variable rotators [GET]

Lists enabled and active secrets rotators running in Conjur.

The `name` field in the response maps to the value of the
`rotation/rotator` annotation placed on variables to be rotated.

---

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of active rotators|

+ Response 200 (application/json; charset=utf-8)

    ```
    [
        {
            "name":"pg-rotator",
            "target_type":"Rotation::Target::Postgresql::Password",
            "target_config":null
        },
        {
            "name":"aws-rotator",
            "target_type":"Rotation::Target::AWS::SecretKey",
            "target_config":null
        }
    ]
    ```
