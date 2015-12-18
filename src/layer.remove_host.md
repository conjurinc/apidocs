## Remove Host [/api/layers/{id}/hosts/{hostid}]

### Remove a host from a layer [DELETE]

Remove a host from an existing layer. All privileges the host gained through layer enrollment are revoked.

Both `id` and `hostid` must be query-escaped: `/` -> `%2F`, `:` -> `%3A`.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)


**Response**

|Code|Description|
|----|-----------|
|204|Host removed from the layer|
|403|Permission denied|
|404|Existing layer or host not found|

+ Parameters
    + id: redis (string) - ID of the layer, query-escaped
    + hostid: cucumber:host:redis001 (string) - Fully qualified ID of the host to remove, query-escaped

+ Request (application/json)
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 204
