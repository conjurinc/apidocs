FORMAT: 1A
HOST: https://conjur.myorg.com

# Conjur API

Welcome to the Conjur API documentation!

Any manipulation of roles, resources and permissions in Conjur can be done through this API.

# Authentication

Most API calls require an authentication access token. To obtain an access token as a user:

1. Use a username and password to obtain an API key (refresh token) with the [Authentication > Login](/#reference/authentication/login) route.
2. Use the API key to obtain an access token with the [Authentication > Authenticate](/#reference/authentication/authenticate) route.

Access tokens expire after 8 minutes. You need to obtain a new token after it expires.
Token expiration and renewal is handled automatically by the
Conjur [CLI](https://developer.conjur.net/cli) and [client libraries](https://developer.conjur.net/clients).

## SSL verification

Use the public key you obtained when running `conjur init` for SSL verification when talking to your Conjur endpoint.
This is a *public* key, so you can check it into source control if needed.

For example, with curl:

```
$ curl --cacert <certfile> ...
```

:[intro.examples](intro.examples.md)

:[intro.retries](intro.retries.md)

# Group Authentication

:[authn.users.login](authn.users.login.md)

:[authn.users.authenticate](authn.users.authenticate.md)

:[authn.users.update](authn.users.update.md)

:[authn.users.update_password](authn.users.update_password.md)

:[authn.users.rotate_api_key](authn.users.rotate_api_key.md)

# Group Variable

A `variable` is a 'secret' and can be any value. It is a `resource`, in RBAC terms.

[Read more](https://developer.conjur.net/key_concepts/secrets.html) about variables.

:[variable.create](variable.create.md)

:[variable.list](variable.list.md)

:[variable.show](variable.show.md)

:[variable.values_add](variable.values_add.md)

:[variable.value](variable.value.md)

:[variable.values](variable.values.md)

:[variable.set_expiration](variable.set_expiration.md)

:[variable.expirations](variable.expirations.md)

# Group Rotation

Some variables can be rotated automatically by annotating them.

[Read more](https://developer.conjur.net/reference/services/rotation) about rotation.

:[rotation.rotators](rotation.rotators.md)

# Group User

A `user` represents an identity for a human. It is a `role`, in RBAC terms.

[Read more](https://developer.conjur.net/reference/services/directory/user/) about users.

:[user.create](user.create.md)

:[user.update](user.update.md)

:[user.list](user.list.md)

:[user.search_by_uid](user.search_by_uid.md)

:[user.show](user.show.md)

# Group Pubkeys

The Conjur pubkeys service can store public keys for all your users, and make them available
throughout your infrastructure.

Public keys can be associated with user login names, or other identifying criteria. You can
load multiple named keys for each user, which is useful when your users have different keys on
different machines.

Public keys are most often used to facilitate SSH login solutions; but you can use the Conjur
public keys facility in any way that you like.

Only members of the group `pubkeys-1.0/key-managers` can manage public keys.

[Read more](https://developer.conjur.net/tutorials/ssh/public-keys.html) about pubkeys.

:[pubkeys.add](pubkeys.add.md)

:[pubkeys.show](pubkeys.show.md)

:[pubkeys.delete](pubkeys.delete.md)

# Group Group

A `group` represents a collection of users or groups.
It is a `role` and a collection of `roles`, in RBAC terms.

Since both users and groups are roles, the routes are used to modify group membership are:
* [Role / Grant To](/#reference/role/grant-to-revoke-from/grant-a-role-to-another-role) - add group member
* [Role / Revoke From](/#reference/role/grant-to-revoke-from/revoke-a-granted-role) - remove group member


[Read more](https://developer.conjur.net/reference/services/directory/group/) about groups.

:[group.create](group.create.md)

:[group.update](group.update.md)

:[group.list](group.list.md)

:[group.search_by_gid](group.search_by_gid.md)

:[group.show](group.show.md)

:[group.list_members](group.list_members.md)

# Group Host

A `host` represents an identity for a non-human. This could be a VM, Docker container, CI job, etc.
It is both a `role` and `resource`, in RBAC terms.

Hosts are grouped into layers.

[Read more](https://developer.conjur.net/reference/services/directory/host/) about hosts.

:[host.create](host.create.md)

:[host.list](host.list.md)

:[host.show](host.show.md)

:[host.layers](host.layers.md)

# Group Layer

A `layer` is a collection of hosts. It is a `role`, in RBAC terms.

Granting privileges on layers instead of the hosts themselves allows for easy auto-scaling.
A host assumes the permissions of the layer when it is enrolled.

[Read more](https://developer.conjur.net/reference/services/directory/layer/) about layers.

:[layer.create](layer.create.md)

:[layer.list](layer.list.md)

:[layer.show](layer.show.md)

:[layer.add_host](layer.add_host.md)

:[layer.remove_host](layer.remove_host.md)

:[layer.permitted_roles](layer.permitted_roles.md)

:[layer.permit_privilege](layer.permit_privilege.md)

:[layer.deny_privilege](layer.deny_privilege.md)

# Group Host Factory

The `Host Factory` is a web service that enables code and scripts to create Hosts and add them to specific Layers,
without having to grant the scripts full administrative privileges on the layers.

A typical flow:

1. You create a host factory and attach it to a layer through the Policy DSL.
2. You (or an automation tool) generate an expiring host factory token.
3. When a new host starts, it uses this token to enroll itself into the layer, assuming the layer's permissions.

To use the Host Factory from the Conjur CLI, install the host-factory plugin:

```
conjur plugin install host-factory
conjur hostfactory -h
```

[Read more](https://developer.conjur.net/reference/services/host_factory) about the Host Factory.

:[host_factory.create](host_factory.create.md)

:[host_factory.list](host_factory.list.md)

:[host_factory.show](host_factory.show.md)

:[host_factory.tokens.create](host_factory.tokens.create.md)

:[host_factory.tokens.show](host_factory.tokens.show.md)

:[host_factory.tokens.revoke](host_factory.tokens.revoke.md)

:[host_factory.hosts.create](host_factory.hosts.create.md)

# Group Role

A `role` is an actor in the system, in the classical sense of role-based access control.
Roles are the entities which receive permission grants.

[Read more](https://developer.conjur.net/reference/services/authorization/role/) about roles.

:[role.create](role.create.md)

:[role.exists](role.exists.md)

:[role.members](role.members.md)

:[role.memberships](role.memberships.md)

:[role.grant_to](role.grant_to.md)

:[role.revoke_from](role.revoke_from.md)

# Group Resource

A `resource` is a record on which permissions are defined.
They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/) about resources.

:[resource.create](resource.create.md)

:[resource.exists](resource.exists.md)

:[resource.show](resource.show.md)

:[resource.list](resource.list.md)

:[resource.give](resource.give.md)

:[resource.permit](resource.permit.md)

:[resource.deny](resource.deny.md)

:[resource.check](resource.check.md)

:[resource.permitted_roles](resource.permitted_roles.md)

:[resource.annotate](resource.annotate.md)

:[resource.list_annotations](resource.list_annotations.md)

# Group Audit

Every privilege modification, variable retrieval and SSH action is logged to an immutable audit trail in Conjur.

You can use the API to retrieve all audit records, to retrieve audit records for a single role or resource, or to retrieve audit records for a set of roles and/or resources.

By default, the number of audit records returned is limited to 100, but this can be adjusted using the `limit` parameter. The maximum number of audit records returned is limited to 10,000.

The number of audit records returned may also be limited using the `till` or `since` parameters, which filter the results returned based on timestamp.

:[audit.all](audit.all.md)

:[audit.single](audit.single.md)

:[audit.multiple](audit.multiple.md)

# Group Utilities

:[utilities.health](utilities.health.md)

:[utilities.info](utilities.info.md)

:[utilities.remote_health](utilities.remote_health.md)

# Group LDAP Sync

:[min_version](partials/min_version_4.8.md)

LDAP Sync is used to generate a policy to synchronize user and group records from Active Directory/LDAP to Conjur.

Before the policy can be generated, you must configure the LDAP Sync connection settings through the Conjur UI LDAP Sync settings page. The UI allows testing of the configuration settings to validate that the users and groups retrieved by the search are correct.

After validating, save your configuration profile in the UI. The UI saves the profile as annotations of the resource `configuration:conjur/ldap-sync/default` and the password in the variable `conjur/ldap-sync/bind-paassword/default`.

[Read more](https://developer.conjur.net/server_setup/tools/ldap_sync.html) about LDAP Sync configuration.

Once the configuration profile is validated and saved, generate the policy using one the following methods:

* CLI: the `conjur ldap-sync policy show` command
* HTTPS: the `policy` route.


:[ldap-sync.policy](ldap-sync.policy.md)
