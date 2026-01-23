# ADR‑0014: IAM & Access Control Model

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform requires a clear, secure, and maintainable IAM model to support:

- ECS task execution and application runtime permissions
- GitHub Actions deployments using OIDC
- Terraform provisioning from the developer workstation
- Least‑privilege access to AWS services such as ECR, CloudWatch Logs, and Parameter Store
- Separation of duties between infrastructure provisioning, CI/CD, and application runtime

IAM complexity can grow quickly if not intentionally constrained. The access control model must remain simple, auditable, and aligned with AWS best practices while supporting future expansion.

---

## Decision

The platform will use a role‑based IAM model with three primary roles:

1. A GitHub Actions deployment role assumed via OIDC  
2. An ECS task role for application runtime permissions  
3. A Terraform execution role used locally via the developer’s AWS credentials  

Each role will follow least‑privilege principles and will be scoped only to the AWS services required for its function. No long‑lived AWS credentials will be stored in GitHub or embedded in the application.

---

## Rationale

### Clear Separation of Responsibilities
- The GitHub Actions role handles deployments, image pushes, and task definition updates.
- The ECS task role provides the application with runtime access to logs, Parameter Store, and other required services.
- Terraform uses the developer’s local AWS credentials and does not share permissions with CI/CD or runtime components.

This separation reduces blast radius and improves auditability.

### Security and Least Privilege
- OIDC removes the need for long‑lived AWS access keys in GitHub.
- ECS tasks receive only the permissions required for runtime behaviour.
- Terraform permissions are limited to infrastructure provisioning and state management.
- No cross‑role permission sharing or privilege escalation paths.

### Operational Simplicity
- Each role has a clear purpose and minimal policy surface area.
- IAM policies can be managed cleanly through Terraform.
- The model scales naturally if additional services or environments are added later.

### Alignment With AWS Best Practices
- OIDC‑based CI/CD authentication is the recommended modern approach.
- ECS task roles are the standard mechanism for granting application permissions.
- Developer‑driven Terraform provisioning avoids unnecessary automation complexity.

---

## Consequences

### Benefits — ADR‑0014
- Strong security posture with no long‑lived credentials in CI/CD
- Clear, auditable separation of duties across deployment, runtime, and provisioning
- Minimal IAM policy footprint, reducing risk of misconfiguration
- Easy to extend as the platform grows
- Aligns with AWS Well‑Architected security principles

### Trade‑offs — ADR‑0014
- Requires careful IAM policy management as new features are added
- Additional roles may be needed if the architecture expands to multiple services
- Developers must maintain local AWS credentials for Terraform usage
- CI/CD workflows depend on correct OIDC configuration

---

## Alternatives Considered

### Using Long‑Lived AWS Credentials in GitHub Secrets
Rejected because:
- Introduces unnecessary security risk
- Requires manual rotation and secret management
- Inferior to OIDC‑based short‑lived credentials

### Using a Single IAM Role for All Functions
Rejected because:
- Violates least‑privilege principles
- Increases blast radius
- Makes auditing and troubleshooting more difficult

### Using Terraform Cloud or a Centralised Provisioning Role
Rejected because:
- Adds cost and operational overhead
- Not required for a single‑developer environment
- Local Terraform execution is simpler and more transparent

---

This IAM and access control model provides a secure, maintainable, and well‑structured foundation for the platform. It enforces least privilege, avoids long‑lived credentials, and cleanly separates deployment, runtime, and provisioning responsibilities.
