## Values Add [/api/variables/{id}/values]

### Add a value to a variable [POST]

Variable ids must be escaped in the url, e.g., `'/' -> '%2F'`.

The body is a JSON object containing:

```
value       - Value of the variable
```

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable


+ Request

    ```
    {
        "value": "np89daed89p"
    }
    ```

+ Response 201 (text/plain)

    ```
    Value added
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Variable not found
    ```

+ Response 422

    ```
    # Value malformed or missing
    ```
