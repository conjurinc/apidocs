## Update [/api/groups/{id}/{?gidnumber}]

### Update a group record [PUT]

You can change a group's GID number with this route.

---

**Header**

|Field|Description|Example|
|----|------------|-------|
|Authorization|Conjur authentication token or Http Basic Auth|"Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=="|

**Response**

|Code|Description|
|----|-----------|
|204|The GID has been updated|
|401|Invalid or missing Authorization header|
|403|Permission denied|
|404|Group not found|

+ Parameters
    + id: ops (string) - Name of the group, query-escaped
    + gidnumber: 63000 (number) - New GID number to set for the group

+ Request
    + Headers

        ```
        Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
        ```
