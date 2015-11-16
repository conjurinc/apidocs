FORMAT: 1A
HOST: https://conjur.myorg.com

# Conjur API

Welcome to the Conjur API documentation!

Any manipulation of roles, resources and permissions in Conjur can be done through this API.

# Authentication

Most API calls require an authentication token. To obtain a token as a user:

1. Use a username and password to obtain an API key with the [Authentication > Login](/#reference/authentication/login) route.
2. Use the API key to obtain an auth token with the [Authentication > Authenticate](/#reference/authentication/authenticate) route. 

Auth tokens expire after 8 minutes. You need to obtain a new token after it expires.
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

# Group Authentication

:[authn.users.login](authn.users.login.md)

:[authn.users.authenticate](authn.users.authenticate.md)

# Group Variable

A `variable` is a 'secret' and can be any value. It is a `resource`, in RBAC terms.

[Read more](https://developer.conjur.net/key_concepts/secrets.html) about variables.

:[variable.create](variable.create.md)

:[variable.list](variable.list.md)

:[variable.show](variable.show.md)

:[variable.values_add](variable.values_add.md)

:[variable.value](variable.value.md)

:[variable.values](variable.values.md)


# Group User

A `user` represents an identity for a human. It is a `role`, in RBAC terms.

[Read more](https://developer.conjur.net/reference/services/directory/user/) about users.

:[user.create](user.create.md)

:[user.update](user.update.md)

:[user.update_password](user.update_password.md)

:[user.list](user.list.md)

:[user.search_by_uid](user.search_by_uid.md)

:[user.show](user.show.md)

# Group Group

A `group` represents a collection of users or groups. It is a `role` and a collection of `roles`, in RBAC terms.

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

:[role.grant_to](role.grant_to.md)

:[role.revoke_from](role.revoke_from.md)

# Group Resource

A `resource` is a record on which permissions are defined. 
They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/) abour resources.

:[resource.create](resource.create.md)

:[resource.exists](resource.exists.md)

:[resource.show](resource.show.md)

:[resource.list](resource.list.md)

:[resource.annotate](resource.annotate.md)

:[resource.list_annotations](resource.list_annotations.md)

:[resource.give](resource.give.md)

:[resource.permit](resource.permit.md)

:[resource.deny](resource.deny.md)

:[resource.check](resource.check.md)

# Group Audit

Every privilege modification, variable retrieval and SSH action is logged to an immutable audit trail in Conjur.

Audit records can be retrieved via the API for everything or a single role/resource.
Fetching all audit records can return a very large response, so it is best to the the `limit` parameter.

:[audit.all](audit.all.md)

:[audit.single](audit.single.md)

# Group Utilities

:[utilities.health](utilities.health.md)
