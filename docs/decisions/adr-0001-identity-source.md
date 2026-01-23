# ADR‑0001: Identity Source for AWS Access

## Status

Accepted

## Date

2026‑01‑23

## Context

This project requires a secure, scalable, and modern authentication mechanism for accessing AWS.  
The identity source must support:

- Short‑lived credentials
- Strong MFA enforcement
- Clear separation between identity and infrastructure
- Compatibility with Terraform and CI/CD workflows
- Minimal operational overhead
- No long‑lived IAM users or access keys

AWS offers several options for identity management:

1. Root account (not suitable for operational use)
2. IAM users (legacy, long‑lived credentials, poor security posture)
3. IAM Identity Center (SSO) with AWS‑managed identity store
4. IAM Identity Center integrated with an external IdP (Azure AD, Okta, etc.)

This project is intentionally self‑contained and does not rely on external identity providers.

## Decision

**IAM Identity Center (SSO) using the AWS‑managed identity store is the chosen identity source for
all human access to AWS.**

A single administrative user is created in the identity store and assigned the `AdministratorAccess`
permission set.  
All future operational access will be granted through SSO permission sets rather than IAM users.

## Rationale

### Security

- Eliminates long‑lived IAM access keys
- Enforces MFA by default
- Provides short‑lived, automatically rotated credentials
- Reduces attack surface compared to IAM users

### Operational Clarity

- Centralised identity management
- Clear audit trails for all console and CLI activity
- Easy to onboard/offboard users without touching IAM

### Terraform Compatibility

- Terraform can authenticate using SSO profiles without requiring IAM users
- No need to manage access keys or secret rotation

### Simplicity

- AWS‑managed identity store avoids external dependencies
- Suitable for a standalone portfolio project
- Easy to extend later if an external IdP is required

## Consequences

### Benefits — ADR‑0001

- Strong security posture from day one
- No IAM users or long‑lived credentials in the account
- Clean, modern authentication workflow for Terraform and CLI
- Easy to scale to multiple permission sets and roles

### Trade‑offs — ADR‑0001

- Requires periodic `aws sso login` for Terraform and CLI usage
- External IdP integration would require a future ADR if needed

## Alternatives Considered

### IAM Users

Rejected due to:

- Long‑lived credentials
- Manual key rotation
- Poor alignment with AWS best practices

### External Identity Provider (Azure AD, Okta)

Rejected for now because:

- Adds unnecessary complexity for a single‑user project
- Requires additional configuration and maintenance
- Provides no meaningful benefit at this stage

---

IAM Identity Center provides the right balance of security, simplicity, and modern AWS practice for
this project.
