## List [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### Find and list resources [GET]

This command includes features such as:

* Full-text search of resource ids and annotations
* Filtering by resource kind
* Search offset and limit
* Display full resource JSON, or IDs only

**Permission Required**

The result only includes resources on which the current role has some privilege.
In other words, resources on which you have no privilege are invisible to you.

+ Parameters
    + account: demo (string) - organization account name
    + kind: host (string) - kind of the resource, for example 'variable' or 'host'
    + search: ec2 (string) - search string
    + limit: 5 (number) - limits the number of response records
    + offset: 0 (number) - offset into the first response record

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
