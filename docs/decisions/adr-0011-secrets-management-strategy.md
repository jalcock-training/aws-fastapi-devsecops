# ADR‑0011: Secrets Management Strategy

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform requires a secure and maintainable approach for managing secrets used by the FastAPI application, ECS tasks, and CI/CD workflows. Secrets may include:

- database credentials (if added later)
- API keys or tokens
- application configuration values
- AWS credentials for GitHub Actions via OIDC
- any sensitive environment variables required by the service

The secrets management solution must:

- avoid storing secrets in the repository
- integrate cleanly with ECS Fargate and GitHub Actions
- support least‑privilege access
- minimise operational overhead
- align with AWS best practices

AWS provides multiple options for secret storage, including Secrets Manager, Systems Manager Parameter Store, and environment variables injected directly into ECS task definitions. GitHub Actions also supports OIDC‑based authentication to AWS, removing the need for long‑lived credentials.

---

## Decision

The platform will use AWS Systems Manager Parameter Store (SecureString parameters) as the primary secrets management solution. ECS task definitions will reference these parameters at runtime, and GitHub Actions will access AWS using OIDC‑based short‑lived credentials rather than stored secrets.

This approach provides secure, low‑cost secret storage with minimal operational complexity.

---

## Rationale

### Security and Least Privilege
- Parameter Store SecureString encrypts secrets using AWS KMS
- IAM policies restrict access to only the ECS task role and CI/CD role
- No long‑lived AWS credentials are stored in GitHub
- Secrets never appear in the repository or container image

### Cost and Simplicity
- Parameter Store is significantly cheaper than Secrets Manager for small projects
- No rotation workflows or advanced features are required at this stage
- ECS integrates natively with Parameter Store for environment variable injection
- Terraform can manage parameter creation and IAM permissions

### CI/CD Integration
- GitHub Actions authenticates to AWS using OIDC, eliminating stored credentials
- Workflows can read or update secrets only when explicitly permitted
- No need for GitHub‑hosted secrets containing AWS keys

### Operational Clarity
- Secrets are stored in a single, well‑defined location
- IAM policies clearly define which roles can read which parameters
- Easy to extend if additional secrets or environments are added later

---

## Consequences

### Benefits — ADR‑0011
- Strong security posture with encrypted, centrally managed secrets
- No long‑lived AWS credentials in GitHub or local development
- Low cost and minimal operational overhead
- Clean integration with ECS Fargate and Terraform
- Clear, auditable IAM permissions for secret access

### Trade‑offs — ADR‑0011
- Parameter Store has lower throughput and feature depth than Secrets Manager
- No built‑in secret rotation (not required for this project)
- ECS tasks must fetch secrets at startup, not dynamically during runtime
- Additional IAM policies must be maintained as new secrets are added

---

## Alternatives Considered

### AWS Secrets Manager
Rejected because:
- Higher cost for a development environment
- Rotation and advanced features are unnecessary for this project
- Parameter Store provides sufficient functionality

### GitHub Secrets
Rejected because:
- Would require storing long‑lived AWS credentials
- Not suitable for runtime secrets used by ECS tasks
- Less secure than AWS‑native secret storage

### Environment Variables in Terraform or Task Definitions
Rejected because:
- Secrets would appear in plaintext in Terraform state
- Violates best practices for secret handling
- Difficult to rotate or audit

---

This secrets management strategy provides a secure, low‑cost, and maintainable foundation for handling sensitive configuration across ECS, Terraform, and GitHub Actions. It aligns with AWS best practices while keeping operational overhead minimal.
