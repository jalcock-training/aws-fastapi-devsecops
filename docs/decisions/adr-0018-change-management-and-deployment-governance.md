# ADR‑0018: Change Management & Deployment Governance

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform uses Terraform for infrastructure provisioning and GitHub Actions for application
deployment. Both represent controlled changes to the environment and must follow a clear governance
model to ensure traceability, auditability, and operational safety.

MAS Technology Risk Management (TRM) guidelines emphasise:

- controlled and auditable change processes
- segregation of duties
- approval workflows for production changes
- traceability of deployments
- rollback mechanisms
- secure handling of CI/CD pipelines

Although this project is a reference implementation and not a regulated financial workload,
documenting a lightweight but disciplined change‑management approach ensures the architecture
remains transparent, predictable, and aligned with MAS‑style expectations.

---

## Decision

The platform will adopt a **lightweight, Git‑based change management model** with the following
characteristics:

- All changes (infrastructure or application) must be made through Pull Requests.
- CI/CD pipelines must validate changes before they are merged.
- The `main` branch is the single source of truth for deployments.
- Infrastructure changes require a reviewed Terraform plan before merging.
- Application deployments occur automatically on merge to `main`.
- Rollbacks are performed by reverting the relevant commit and redeploying.

This model provides clear governance without introducing unnecessary complexity.

---

## Rationale

### Alignment with MAS TRM Expectations

- Pull Requests provide traceability, review, and approval.
- CI/CD pipelines enforce consistency and reduce manual error.
- Terraform plans provide visibility into infrastructure changes before execution.
- Git history provides an immutable audit trail.

### Segregation of Duties (Practical Interpretation)

- Code authors and reviewers are distinct roles, even in a single‑developer context.
- CI/CD performs deployments, not developers directly.
- IAM roles ensure GitHub Actions has only the permissions required for deployment.

### Predictability and Safety

- All changes are version‑controlled.
- Infrastructure and application changes follow the same workflow.
- Rollbacks are deterministic and fast due to stateless design.
- No manual changes are made in the AWS console.

### Operational Simplicity

- No external change‑management tooling is required.
- The workflow remains lightweight and developer‑friendly.
- The model can scale to multi‑developer teams if needed.

---

## Consequences

### Benefits — ADR‑0018

- Clear, MAS‑aligned change‑management model
- Full traceability of all infrastructure and application changes
- Automated, consistent deployments
- Simple rollback mechanism
- No manual or ad‑hoc changes to cloud resources
- Easy to extend to more formal governance if required

### Trade‑offs — ADR‑0018

- No formal approval workflow beyond Pull Request review
- No automated change‑window enforcement
- No integration with enterprise change‑management systems
- Single‑region deployment means changes affect all availability zones simultaneously

---

## Alternatives Considered

### Formal Change‑Management System (ServiceNow, Jira, etc.)

Rejected because:

- Overkill for a reference implementation
- Adds operational overhead
- Not aligned with the goal of a minimal, clear architecture

### Manual Deployments or Console‑Driven Changes

Rejected because:

- Not auditable
- Error‑prone
- Violates MAS TRM expectations
- Breaks reproducibility and IaC discipline

### GitOps‑Style Deployment (ArgoCD, Flux)

Rejected because:

- Adds significant complexity
- Requires additional infrastructure and operational knowledge
- Not necessary for a single‑service architecture

---

This change‑management and deployment governance model provides a clear, MAS‑aligned foundation for
controlled, auditable, and predictable changes while maintaining the simplicity and reproducibility
of the platform.
