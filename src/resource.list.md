## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists resources according to visibility rules and search parameters.

Only resources which are "visible" to the calling role will be returned, no matter what filter parameters are provided. A resource is visible to the calling role if:

* The calling role, or some role held by the calling role, owns the resource.
* The calling role, or some role held by the calling role, has a privilege (any privilege) on the resource.
* The request is using the `reveal` or `elevate` [global permission](https://developer.conjur.net/reference/services/authorization/global_permissions.html). 

This command includes some the following search parameters which can be used to select specific resources.

#### Full-text search

The `search` parameter can be used to perform a full-text search. The `id` of each resource and the `value` of each annotation are full-text indexed in the database. This parameter can be used to search over those values using the Postgresql function [plainto_tsquery](http://www.postgresql.org/docs/9.3/static/textsearch-controls.html#TEXTSEARCH-PARSING-QUERIES). The simplest way to use this feature is to simply provide a string containing keywords. 

The search results are weighted by the following factors:

* `A (1.0)` resource `id` and the `name` annotation
* `B (0.4)` annotations other than `name`
* `C (0.2)` resource `kind`

#### Filtering by resource kind

The `kind` parameter can be used to filter resources by kind. 

#### Offset and limit

The `offset` parameter indicates a 0-based offset into the result set. `limit` limits the maximum number of results returned, starting with the `offset`.

#### Filtering by owner

The `owner` parameter selects only those resources which are owned by the indicated role, or by any role held by the `owner`. 

#### Filtering by resource path

:[min_version](partials/min_version_4.7.md)
 
The `id`s of the resources form an implicit hierarchy. For example, it can be useful to treat a resource such as `dev/myapp/ssl_certificate` as a child of `dev/myapp`. The `path` and `path_text` parameters can be used to navigate over these relationships.

Each resource id is normalized to a "path" string, which can then be searched over using the Postgresql
[ltree](http://www.postgresql.org/docs/9.3/static/ltree.html) module. 

The transformation from a resource id to a path occurs like this:

1. If the resource id contains any forward slash `/` characters, then all period `.` characters are converted to
underscores, and all forward slashes are converted to periods.

2. "colon" `:` and "at" `@` characters are converted to periods.

3. All characters aside from periods and alphanumerics are converted to underscores.

4. The `account`, `kind`, and `id` are joined together using period characters.

5. The entire string is converted to lower-case.

*Path examples*

|Resource Id|Resource Path|
|----|-----------|
| mycorp:variable:myapp/ssl-certificate | mycorp.variable.myapp.ssl_certificate |
| mycorp:host:host-01.mycorp.com | mycorp.host.host_01.mycorp.com |
| mycorp:policy:dev/myapp-1.0 | mycorp.policy.dev.myapp\_1\_0 |

The `path` parameter is treated as an `lquery` and applied to the resource ids using the `~` operator.

The `path_text` parameter is treated as an `ltxtquery` and applied to the resource ids using the `@` operator.

*Path search examples*

* `mycorp.policy.dev.*{1,}` Find all policies in the `dev` namespace.
* `mycorp.policy.*{1,}.mycorp.com` Find all hosts in the `mycorp.com` domain.

#### Has annotation

The `has_annotation` parameter selects only resources which have a specified annotation (regardless of the annotation value).

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
    + search: ssl_certificate (string, optional) - full-text search string
    + limit (string, optional) - limits the number of response records
    + offset (string, optional) - offset into the first response record
    + path (string, optional) - `lquery` search against the resource id path (Conjur 4.7 and later)
    + path_text (string, optional) - `ltxtquery` search against the resource id path (Conjur 4.7 and later)

+ Request
    :[conjur_auth_header_code](partials/conjur_auth_header_code.md)

+ Response 200 (application/json)

    ```
    [
      {
        "id": "cucumber:variable:aws_keys",
        "owner": "cucumber:group:ops",
        "permissions": [],
        "annotations": []
      }
    ]
    ```
