# Root Account Setup

This document outlines the initial security hardening applied to the AWS root account. The root user
is not used for day‑to‑day operations and exists only for break‑glass scenarios.

## Actions Completed

- Enabled MFA on the root account
- Verified no root access keys exist
- Added alternate security, billing, and operations contacts
- Stored recovery codes securely offline
- Logged out and confirmed no further root usage required

## Principles

- Root is never used for infrastructure deployment
- All operational access is delegated through IAM Identity Center (SSO)
- Break‑glass access is documented but intentionally difficult to use
