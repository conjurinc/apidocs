## Create [/api/variables]

### Create a new variable [PUT]

This is a 'secret' in Conjur and can be any value.

A variable can be created with or without an initial value.
If you don't give the variable an `id` one will be randomly generated.

The body is a JSON object containing:

```
id          - Name of the variable, optional
ownerid     - Owner of the variable
mime_type   - Media type of the variable
kind        - Purpose of the variable, optional
value       - Value of the variable, optional
```

+ Request

    ```
    {
        "id": "dev/mongo/password",
        "ownerid": "demo:group:developers",
        "kind": "password",
        "mime_type": "text/plain",
        "value": "p89b12ep12puib"
    }
    ```

+ Response 201 (application/json)

    ```
    {
        "id": "dev/mongo/password",
        "userid": "demo",
        "mime_type": "text/plain",
        "kind": "password",
        "ownerid": "demo:group:developers",
        "resource_identifier": "demo:variable:dev/mongo/password",
        "version_count": 1
    }
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 409

    ```
    # Variable with that name already exists
    ```
