## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists all resources the calling identity has a privilege on (or owns).

The list can be filtered by a variety of search options:

* **search** Performs a full-text search.
* **has_annotation** Selects only resources which have a specified annotation (regardless of the annotation value).
* **path**, **path_text** Selects only resources which match a path specifier.

You can also limit, offset and shorten the resulting list.

**search**

The search parameter is used to perform a full-text search. Resource id, kind and annotation values are full-text
indexed in Conjur. The highest search weight is given to the resource id and the `name` annotation (if any). 
Second highest search weight is annotation value text, and the lowest search weight is the resource kind.

On the backend, the `search` parameter is converted to a Postgresql [tsquery](http://www.postgresql.org/docs/9.3/static/datatype-textsearch.html) using the function `to_tsquery`.

**has_annotation**

This parameter is used to select only resources that have a specified annotation.

**path** and **path_text**

Each resource id is normalized to a "path" string, which can then be searched over using the Postgresql
[ltree](http://www.postgresql.org/docs/9.3/static/ltree.html) module. 

The transformation from a resource id to a path occurs like this:

1. If the resource id contains any forward slash `/` characters, then all period `.` characters are converted to
underscores, and all forward slashes are converted to periods.

2. Colon `:` and "at" `@` characters are converted to periods.

3. All characters aside from periods and alphanumerics are converted to underscores.

4. The `account`, `kind`, and `id` are joined together using period characters.

5. The entire string is converted to lower-case.

*Path Examples*

|Resource Id|Resource Path|
|----|-----------|
| mycorp:variable:myapp/ssl-certificate | mycorp.variable.myapp.ssl_certificate |
| mycorp:host:host-01.mycorp.com | mycorp.host.host_01.mycorp.com |
| mycorp:policy:dev/myapp-1.0 | mycorp.policy.dev.myapp\_1\_0 |

`path` is evaluated using the ltree `~` operator. `path_text` is evaluated using `@`.

*Search Examples*

* `mycorp.policy.dev.*{1,}` Find all policies in the `dev` namespace.
* `mycorp.policy.*{1,}.mycorp.com` Find all hosts in the `mycorp.com` domain.

**Permission Required**

The result only includes resources on which the current role has some privilege. In other words, resources on which you have no privilege are invisible to you.

---

:[conjur_auth_header_table](partials/conjur_auth_header_table.md)

**Response**

|Code|Description|
|----|-----------|
|200|JSON list of visible resources|

+ Parameters
    + account: demo (string) - organization account name
    + kind: variable (string) - kind of the resource, for example 'variable' or 'host'
    + search: ssl_certificate (string, optional) - search string
    + limit (string, optional) - limits the number of response records
    + offset (string, optional) - offset into the first response record

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json; charset=utf-8)

    ```
    [
      {
        "id": "cucumber:variable_group:aws_keys",
        "owner": "cucumber:group:ops",
        "permissions": [],
        "annotations": []
      }
    ]
    ```
