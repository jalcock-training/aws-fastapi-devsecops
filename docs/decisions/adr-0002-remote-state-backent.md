# ADR‑0002: Remote State Backend (S3 + DynamoDB)

## Status

Accepted

## Date

2026‑01‑23

## Context

Terraform requires a backend to store state, manage concurrency, and ensure consistent deployments.
Local state is not suitable for a collaborative or automated environment because it:

- cannot be shared between users or CI/CD pipelines
- is prone to accidental deletion or corruption
- provides no locking, leading to race conditions
- does not support secure, versioned storage

A remote backend is required to support:

- GitHub Actions CI/CD workflows
- reproducible infrastructure deployments
- safe state locking
- secure, durable storage
- clear separation between code and state

AWS offers several backend options:

- S3 + DynamoDB (native Terraform backend)
- Terraform Cloud / Terraform Enterprise
- SSM Parameter Store (not recommended)
- Custom backends (not required for this project)

The backend must be simple, cost‑effective, and fully under project control.

## Decision

**Terraform state will be stored in an S3 bucket with DynamoDB table locking.**

This backend will be created and managed via Terraform, but bootstrapped manually for the initial
apply.

## Rationale

### Security

- S3 provides encrypted, durable storage
- DynamoDB locking prevents concurrent state modification
- IAM Identity Center authentication ensures short‑lived credentials
- No external services or credentials required

### Reliability

- S3 versioning protects against accidental state corruption
- DynamoDB locking prevents race conditions during CI/CD runs
- Highly available and fully managed by AWS

### Cost

- S3 storage costs are negligible for Terraform state files
- DynamoDB locking table costs are effectively zero at this scale
- No subscription fees (unlike Terraform Cloud)

### Simplicity

- Native Terraform support
- Easy to integrate with GitHub Actions
- No additional services or accounts required
- Works seamlessly with multi‑environment structures

### Alignment with Project Goals

- Matches the platform‑first DevSecOps approach
- Ensures infrastructure is reproducible and safe from day one
- Supports future expansion to staging/production environments

## Consequences

### Benefits — ADR‑0002

- Safe, shared state for both local and CI/CD workflows
- Strong locking guarantees
- Minimal operational overhead
- Fully AWS‑native solution

### Trade‑offs — ADR‑0002

- Initial backend resources must be created manually or via a bootstrap script
- Slightly more setup complexity compared to local state

## Alternatives Considered

### Terraform Cloud

Rejected due to:

- External dependency
- Requires additional accounts and configuration
- Paid tiers for advanced features
- Less aligned with AWS‑native approach

### Local State

Rejected due to:

- No locking
- No shared access
- High risk of corruption
- Not suitable for CI/CD

### SSM Parameter Store

Rejected due to:

- Not designed for Terraform state
- No locking mechanism
- Poor tooling support

---

Using S3 + DynamoDB provides a secure, reliable, and AWS‑native backend that aligns with the
project’s DevSecOps and platform‑engineering goals.
