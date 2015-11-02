FORMAT: 1A

# Conjur API

Welcome to the Conjur API documentation.

Any manipulation of resources in Conjur can be done through this RESTful API.
Most API calls require authentication.

## Group Authentication

:[authn.users.login](authn.users.login.md)

:[authn.users.authenticate](authn.users.authenticate.md)

## Group Role

A `role` is an actor in the system, in the classical sense of role-based access control. Roles are the entities which receive permission grants.

[Read more](https://developer.conjur.net/reference/services/authorization/role/)

:[role.members](role.members.md)

:[role.grant_to](role.grant_to.md)

:[role.revoke_from](role.revoke_from.md)

## Group Resource

A `resource` is a record on which permissions are defined. They are partitioned by "kind", such as "group", "host", "file", "environment", "variable", etc.

[Read more](https://developer.conjur.net/reference/services/authorization/resource/)

:[resource.list](resource.list.md)

:[resource.check](resource.check.md)

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

## Group Variable

A `variable` is a 'secret' and can be any value.

:[variable.create](variable.create.md)

:[variable.show](variable.show.md)

:[variable.value](variable.value.md)

:[variable.values_add](variable.values_add.md)

## Group Utilities

:[utilities.health](utilities.health.md)
