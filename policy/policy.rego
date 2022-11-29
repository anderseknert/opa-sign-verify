package policy

import future.keywords.in

allow {
    "admin" in input.user.roles
}