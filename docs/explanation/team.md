# Team

Everything in NAIS is organized around the concept of a team.

A team is a group of people, typically working on the same set of products or services, and sharing the same set of responsibilities. 

The team owns the workloads built by the team, as well as all provisioned resources. Nothing is owned by an individual, but by the team as a whole. This is to ensure that the team can continue to operate even if a member leaves the team.

A team doesn't necessarily map directly to the organizational team unit, and usually consists of technical people involved in the actual development and operations. The reason for this is that being member of a NAIS team will grant you access to all the workloads and provisioned resources that the team owns. To reduce the attack surface, it's a good idea to limit access to the people that actually need it.

## The anatomy of a team

A team has two different roles, `owner` and `member`. 
A team has at least one `owner`, and can have multiple `members`. The `owners` have permission to add and remove `members`, as well changing the roles of the `members`.
You can be a member and owner of multiple teams.

## What does NAIS provide a team?

When you [create a team](../how-to/create-team.md), NAIS will ensure you have the following:

- A isolated area for your team's workload, in each environment (e.g. dev and prod)
- A GitHub team with the same name, in your GitHub organization. The members of your NAIS team will be synchronized with the GitHub team.


TODO:
- Requirement: google user
























