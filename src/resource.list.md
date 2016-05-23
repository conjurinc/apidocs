## List/Search [/api/authz/{account}/resources/{kind}{?search,limit,offset}]

### List or search for resources [GET]

Lists all resources that the calling identity some privilege on.

This command includes some useful features for selecting specific subsets of resources. 

#### Implicit visibility

Only resources which are "visible" to the calling role will be returned, no matter what filter parameters are provided. A resource is visible to the calling role if:

* The calling role, or some role held by the calling role, owns the resource.
* The calling role, or some role held by the calling role, has a privilege (any privilege) on the resource.
* The request is using the `reveal` or `elevate` [global permission](https://developer.conjur.net/reference/services/authorization/global_permissions.html). 

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
 
The `id`s of the resources form an implicit hierarchy. For example, it can be useful to treat a resource such as `dev/myapp/ssl_certificate` as a child of `dev/myapp`. Specifically, each resource id is converted to an [ltree](http://www.postgresql.org/docs/9.3/static/ltree.html) by replacing forward slashes `/` with periods `/`. 

The `path` parameter is treated as an `lquery` and applied to the resource ids using the `~` operator.

The `path_text` parameter is treated as an `ltxtquery` and applied to the resource ids using the `@` operator.

**Notes** 

* Periods occurring in ids such as `myapp-1.0` are converted to underscores
* ids which already look like period-delimited ltrees (such as host names) are left unmodified.

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
    + kind: variable_group (string) - kind of the resource, for example 'variable' or 'host'
    + search: aws_keys (string, optional) - full-text search string
    + limit (string, optional) - limits the number of response records
    + offset (string, optional) - offset into the first response record
    + path (string, optional) - `lquery` search against the resource id path (Conjur 4.7 and later)
    + path_text (string, optional) - `ltxtquery` search against the resource id path (Conjur 4.7 and later)

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
