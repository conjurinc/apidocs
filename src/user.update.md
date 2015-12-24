## Update [/api/users/{login}{?uidnumber}]

### Update a user record [PUT]

Update a user's UID number with this route.

**Permission Required**: `update` permission on the user resource.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Request Body**

The new password, in the example "n82p9819pb12d12dsa".

**Response**

|Code|Description|
|----|-----------|
|204|The password/UID has been updated|
|401|Invalid or missing Authorization header|
|403|Permission denied|
|404|User not found|

+ Parameters
    + login: bob (string) - Login name of the user, query-escaped
    + uidnumber: `57000` (number, optional) - New UID number to set for the user

+ Request
    :[conjur_auth_header_table](partials/conjur_auth_header_code.md)

+ Response 204
