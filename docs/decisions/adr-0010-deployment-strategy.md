# ADR‑0010: Deployment Strategy

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform requires a reliable, predictable, and low‑risk deployment strategy for updating the
FastAPI service running on ECS Fargate. The deployment approach must:

- minimise downtime
- avoid serving inconsistent versions during rollout
- integrate cleanly with GitHub Actions
- support automated CI/CD workflows
- remain simple enough for a single‑service architecture
- align with AWS best practices for ECS

ECS supports several deployment types, including rolling updates, blue/green deployments via
CodeDeploy, and complete service replacement. Each option has different trade‑offs in terms of
complexity, cost, and operational overhead.

Because this environment is used for development and portfolio demonstration rather than production
workloads, the deployment strategy should prioritise simplicity and clarity over advanced
traffic‑shifting features.

---

## Decision

The platform will use ECS Fargate’s native rolling update deployment strategy. ECS will gradually
replace old tasks with new tasks while maintaining the desired count and ensuring the service
remains available during deployment.

This approach avoids the complexity of CodeDeploy‑based blue/green deployments while still providing
safe, predictable rollouts.

---

## Rationale

### Simplicity and Maintainability

- Rolling updates are built into ECS and require no additional AWS services
- No need to configure CodeDeploy, traffic shifting, or lifecycle hooks
- Easy to understand and maintain for a single‑service environment

### Low Operational Overhead

- No additional cost beyond ECS and ALB usage
- No need for separate target groups or listener rules
- Fewer moving parts reduces the risk of misconfiguration

### Sufficient Safety for a Development Environment

- ECS ensures that at least one task remains healthy during deployment
- ALB health checks prevent traffic from being routed to unhealthy tasks
- Failures automatically roll back without manual intervention

### CI/CD Alignment

- GitHub Actions can trigger deployments simply by pushing a new container image and updating the
  task definition
- No additional pipeline stages or CodeDeploy integrations required
- Clear, predictable behaviour for reviewers and contributors

---

## Consequences

### Benefits — ADR‑0010

- Simple, predictable deployments with minimal configuration
- No additional AWS services or cost
- Safe rollouts with automatic rollback on failure
- Clean integration with GitHub Actions and Terraform
- Easy for contributors to understand and operate

### Trade‑offs — ADR‑0010

- No traffic‑shifting or canary capabilities
- Cannot run two fully isolated environments simultaneously during deployment
- Blue/green rollback is slower because tasks must be replaced rather than switching target groups
- Not suitable for high‑traffic production systems requiring zero‑impact deploys

---

## Alternatives Considered

### Blue/Green Deployments via CodeDeploy

Rejected because:

- Adds significant complexity for a single‑service environment
- Requires additional target groups, listener rules, and CodeDeploy configuration
- Provides benefits (canary, traffic shifting) not required for this project

### Complete Service Replacement

Rejected because:

- Causes brief downtime during task replacement
- Does not leverage ECS’s built‑in deployment safety mechanisms

### Manual Deployments

Rejected because:

- Not aligned with CI/CD best practices
- Increases operational risk and reduces reproducibility

---

This deployment strategy provides a clean, maintainable, and low‑risk approach suitable for a
development‑focused ECS Fargate environment. It aligns with AWS best practices while avoiding
unnecessary complexity.
