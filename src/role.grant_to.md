## Grant to / Revoke from [/api/authz/{account}/roles/{role_a}/{role_id}?members&member={role_b}]

### Grant a role to another role [PUT]

All of this role's privileges are thereby granted to the new role.

When granted with `admin_option`, the grantee (given-to) role can grant the grantor (given-by) role to others.

`admin_option` is passed in the request body.

**Permission Required**: Admin option on the role


+ Parameters
    + account: demo (string) - organization account name
    + role_a: layer/webhosts (string) - ID of the owner role
    + role_b: group:v1/ops (string) - ID of the role we're granting membership to

+ Request

    ```
    {admin_option: true}
    ```

+ Response 200 (text/plain)

    ```
    Role granted
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Role does not exist
    ```
