## Search by GID [/api/groups/search{?gidnumber}]

### Search for groups by GID number [GET]

If you set GID numbers for your groups, you can search on that field.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of group names matching the GID|
|403|Permission denied|

+ Parameters
    + gidnumber: 63000 (number) - GID to match on

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
        "ops"
    ]
    ```
