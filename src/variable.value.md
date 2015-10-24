## Value [/api/variables/{id}/value?version={version}]

### Retrieve the value of a variable [GET]

By default this returns the latest version of a variable, but you can retrieve any earlier version as well.

Variable IDs must be escaped in the url, e.g., `'/' -> '%2F'`.

+ Parameters
    + id: dev/mongo/password (string) - Name of the variable
    + version (string, optional) - Version of the variable to retrieve

+ Response 200 (text/plain)

    ```
    p89b12ep12puib
    ```

+ Response 403

    ```
    # Invalid permissions
    ```

+ Response 404

    ```
    # Variable not found
    ```
