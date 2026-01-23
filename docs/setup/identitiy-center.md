# IAM Identity Center Setup

IAM Identity Center (SSO) is used as the primary authentication and authorization mechanism for this
environment.

## Actions Completed

- Enabled IAM Identity Center in the management account
- Configured AWS-managed identity store
- Created the first administrative user
- Assigned the `AdministratorAccess` permission set
- Verified SSO login and console access

## Rationale

Using SSO provides:

- Centralised identity management
- Short‑lived credentials
- No long‑lived IAM users or access keys
- Clear separation between identity and infrastructure
