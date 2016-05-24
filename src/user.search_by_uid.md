## Search by UID [/api/users/search{?uidnumber}]

### Search for users by UID number [GET]

If you set UID numbers for your users, you can search on that field.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of usernames matching the UID|
|403|Permission denied|

+ Parameters
    + uidnumber: `57000` (number) - UID to match on

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
        "alice"
    ]
    ```
