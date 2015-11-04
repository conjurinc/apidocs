## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists all resources the calling identity has `read` privilege on.

Run a full-text search of the resources with the `search` parameter.

You can also limit, offset and shorten the resulting list.

**Permission Required**

The result only includes resources on which the current role has some privilege.
In other words, resources on which you have no privilege are invisible to you.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of visible resources|

+ Parameters
    + account: demo (string) - organization account name
    + kind: host (string) - kind of the resource, for example 'variable' or 'host'
    + search: ec2 (string, optional) - search string
    + limit (number, optional) - limits the number of response records
    + offset (number, optional) - offset into the first response record

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
        {
            "id": "conjurops:host:ec2/i-2e3c83df",
            "owner": "conjurops:group:v4/build",
            "permissions": [
              {
                "privilege": "execute",
                "grant_option": false,
                "resource": "conjurops:host:ec2/i-2e3c83df",
                "role": "conjurops:@:layer/build-0.1.0/jenkins/use_host",
                "grantor": "conjurops:deputy:production/jenkins-2.0/jenkins-slaves"
              },
              {
                "privilege": "read",
                "grant_option": false,
                "resource": "conjurops:host:ec2/i-2e3c83df",
                "role": "conjurops:host:ec2/i-2e3c83df",
                "grantor": "conjurops:deputy:production/jenkins-2.0/jenkins-slaves"
              }
            ],
            "annotations": {
            }
          }
    ]
    ```
