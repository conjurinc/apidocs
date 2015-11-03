FORMAT: 1A

# Conjur API

Welcome to the Conjur API documentation.

Any manipulation of resources in Conjur can be done through this RESTful API.
Most API calls require authentication.

## Group Authentication

:[authn.users.login](authn.users.login.md)

:[authn.users.authenticate](authn.users.authenticate.md)

## Group Variable

A `variable` is a 'secret' and can be any value.

:[variable.create](variable.create.md)

:[variable.show](variable.show.md)

:[variable.value](variable.value.md)

:[variable.values_add](variable.values_add.md)

## Group User

A `user` represents an identity for a human.

:[user.create](user.create.md)

:[user.show](user.show.md)

:[user.update_password](user.update_password.md)

## Group Group

A `group` represents a collection of users.

:[group.create](group.create.md)

:[group.show](group.show.md)

:[group.list_members](group.list_members.md)

## Group Host

A `host` represents an identity for a non-human. This could be a VM, Docker container, CI job, etc.

Hosts are grouped into layers.

[Read more](https://developer.conjur.net/reference/services/directory/host/) about hosts.

:[host.create](host.create.md)

:[host.list](host.list.md)

:[host.show](host.show.md)

:[host.layers](host.layers.md)

## Group Layer

A `layer` is a collection of hosts.

Granting privileges on layers instead of the hosts themselves allows for easy auto-scaling.
A host assumes the permissions of the layer when it is enrolled.

[Read more](https://developer.conjur.net/reference/services/directory/layer/) about layers.

:[layer.create](layer.create.md)

:[layer.list](layer.list.md)

:[layer.show](layer.show.md)

:[layer.add_host](layer.add_host.md)

:[layer.remove_host](layer.remove_host.md)

## Group Role

A `role` is an actor in the system, in the classical sense of role-based access control. 
Roles are the entities which receive permission grants.

[Read more](https://developer.conjur.net/reference/services/authorization/role/)

:[role.members](role.members.md)

:[role.grant_to](role.grant_to.md)

:[role.revoke_from](role.revoke_from.md)

## Group Resource

A `resource` is a record on which permissions are defined. 
They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/)

:[resource.list](resource.list.md)

:[resource.check](resource.check.md)

## Group Utilities

:[utilities.health](utilities.health.md)
