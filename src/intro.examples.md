# Examples

## Obtain an access token

Let's say your username for Conjur is `samantha`, and your password is `hfsdfp91opifouhw`.
Your Conjur endpoint is hosted at `https://conjur.mybigco.com`.

You have already obtained the public SSL cert by running `conjur init` against your endpoint; the cert was saved as
`~/conjur-mybigco.pem`.

Let's get your API key (refresh token) with the [Authentication > Login](/#reference/authentication/login) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
--user samantha:hfsdfp91opifouhw \
https://conjur.mybigco.com/api/authn/users/login

14m9cf91wfsesv1kkhevdywm2wvqy6s8sk53z1ngtazp1t9tykc
```

Great, you now have your refresh token! Let's use that to obtain an access token we can use for further requests.

Using the [Authentication > Authenticate](/#reference/authentication/authenticate) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
--data "14m9cf91wfsesv1kkhevdywm2wvqy6s8sk53z1ngtazp1t9tykc" \
https://conjur.mybigco.com/api/authn/users/samantha/authenticate

{
    "data": "samantha",
    "timestamp": "2015-10-24 20:31:50 UTC",
    "signature": "BpR0FEb...w4397",
    "key": "15ab2712d65e6983cf7107a5350aaac0"
}
```

We now have our access token in *raw* format. To be able to use it for future requests, we must encode it.

`$response` in the following command is the JSON response from the last API call.

```
$ token=$(echo -n $response | base64 | tr -d '\r\n')
```

Now that you have your encoded token, you can use it to call any other API route. 
For example, adding setting a new value for the variable `redis/password`:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
--data "mynewsecretvalue" \
https://conjur.mybigco.com/api/variables/redis%2Fpassword/values
```

Note that you can use the Conjur CLI to obtain an access token as well, by running `conjur authn authenticate -H`.

[Here is an example](https://github.com/conjurinc/apidocs/blob/master/get_auth_token.sh) 
of obtaining a formatted auth token with a bash script.

---

## Create a host-factory token

Let's say we want to create a new token for an existing host factory.

The host factory's name is `prod/redis_factory`. This factory generates token that allow hosts to enroll in the
`prod/redis` layer, which has permission to access the credentials for your production redis cluster.

You've already [obtained an access token](/#introduction/examples/obtain-an-auth-token) and set it to the bash variable `token`.

Let's set the host factory token to expire in one hour. Expiration timestamps are in 
[ISO8601 format](http://ruby-doc.org/stdlib-2.1.1/libdoc/time/rdoc/Time.html#class-Time-label-Converting+to+a+String)
and must be URL-encoded.

So, if right now is 2:01pm EST on Nov 16th 2015, one hour from now in ISO8601 is `2015-11-16T14:01:00-05:00`.
The timestamp must be URL-encoded in the route.

Create the host factory token with the [Host Factory > Create Token](/#reference/host-factory/create-token) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/host_factories/prod%2Fredis_factory/tokens?expiration=2015-11-16T14%3A01%3A00-05%3A00

[
  {
    "token": "3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q32",
    "expiration": "2015-11-16T20:01:00Z"
  }
]
```

The expiration timestamp in the response is in UTC time.

Now you can use this host factory token to create hosts pre-enrolled in the `prod/redis_factory` layer using
the [Host Factory > Create Host](/#reference/host-factory/create-host) route.

```
$ hftoken="3y9e0573sj436f3h12s0v1hvbfya3xfvpt22q32"

$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$hftoken\"" \
https://conjur.mybigco.com/api/host_factories/hosts?id=redis002

{
  "id": "redis002",
  "userid": "deputy/prod/redis_factory",
  "created_at": "2015-11-16T22:57:14Z",
  "ownerid": "conjur:group:ops",
  "roleid": "conjur:host:redis002",
  "resource_identifier": "conjur:host:redis002",
  "api_key": "14x82x72syhnnd1h8jj24zj1kqd2j09sjy3tddwxc35"
}
```

---

## Permit a group to read a variable

Let's say you want to allow your `mobile/developers` to read a [Firebase](https://www.firebase.com) key stored in Conjur.

The key is stored in the Conjur variable `firebase.com/mobile/secret-token` and owned by the group `security_admin`.

You've already [obtained an access token](/#introduction/examples/obtain-an-auth-token) and set it to the bash variable `token`.

For this example, your Conjur org is `mybigco`, this is the `orgaccount` parameter you gave to `evoke configure` when you
set up your Conjur install. You can also view your Conjur org in the CLI with `conjur authn whoami`.

Okay, so let's give those mobile developers access with the [Resource > Permit](/#reference/resource/permit) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/authz/account/mybigco/variable/firebase.com%2Fmobile%2Fsecret-token/?permit&privilege=execute&role=group:mobile/developers
```

You just gave the group `mobile/developers` the privilege `execute` on the variable `firebase.com/mobile/secret-token`.
This means that everyone in that group can now fetch the firebase key from the variable.

We can check that that is indeed the case with the [Resource > Check](/#reference/resource/check) route:

```
$ curl --cacert ~/.conjur-mybigco.pem \
-H "Authorization: Token token=\"$token\"" \
https://conjur.mybigco.com/api/authz/account/mybigco/roles/mobile%2Fdevelopers/?check&privilege=execute&resource_id=variable:firebase.com/mobile/secret-token
```

A response code of 204 means that the permission exists.
