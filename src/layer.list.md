## List [/api/layers]

### List layers [GET]

Lists all layers the calling identity has `read` privilege on.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of layers returned|
|403|Permission denied|

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "jenkins/slaves",
        "userid": "demo",
        "ownerid": "demo:group:ops",
        "roleid": "demo:layer:jenkins/slaves",
        "resource_identifier": "demo:layer:jenkins/slaves",
        "hosts": [
            "demo:host:slave01"
        ]
      },
      {
        "id": "web/app1",
        "userid": "demo",
        "ownerid": "demo:group:developers",
        "roleid": "demo:layer:web/app1",
        "resource_identifier": "demo:layer:web/app1",
        "hosts": [
            "demo:host:app1-01",
            "demo:host:app1-02",
            "demo:host:app1-03"
        ]
      }
    ]
    ```
