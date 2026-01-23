# ADR‑0006: CI/CD Platform (GitHub Actions)

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform requires a CI/CD solution that supports:

- automated testing, scanning, and deployment of a FastAPI microservice
- Terraform workflows (plan, apply, validation)
- container image builds and vulnerability scanning
- integration with GitHub as the source‑of‑truth repository
- minimal operational overhead
- strong alignment with industry practices for small to medium‑sized cloud platforms

Several CI/CD platforms are available:

1. GitHub Actions  
2. AWS CodePipeline / CodeBuild  
3. GitLab CI  
4. CircleCI  
5. Jenkins (self‑hosted)

The chosen platform must be simple to maintain, widely understood by reviewers, and tightly integrated with the repository.

---

## Decision

**GitHub Actions is selected as the CI/CD platform for building, scanning, and deploying the application and infrastructure.**

This provides a fully managed, repository‑native automation environment with strong ecosystem support.

---

## Rationale

### Integration and Developer Experience
- Native integration with GitHub repositories
- First‑class support for pull request workflows
- Built‑in secrets management
- Easy to trigger workflows on pushes, tags, or PRs
- Clear logs and traceability for reviewers

### Ecosystem and Tooling
- Extensive marketplace of reusable actions
- Strong support for Terraform, Docker, Trivy, Bandit, pip‑audit, and other DevSecOps tools
- Well‑maintained community and vendor‑provided actions
- Easy integration with AWS authentication via OIDC

### Security
- GitHub OIDC federation allows short‑lived AWS credentials without storing long‑lived secrets
- Fine‑grained permissions per workflow
- Built‑in dependency scanning and code security features

### Operational Efficiency
- Fully managed runners (no servers to maintain)
- Optional self‑hosted runners if needed later
- Predictable execution environment
- No need to manage AWS CodeBuild/CodePipeline resources

### Industry Alignment
- GitHub Actions is widely adopted across engineering teams
- Familiar to hiring managers and reviewers
- Strong alignment with modern DevSecOps practices

---

## Consequences

### Benefits — ADR‑0006
- Simple, maintainable CI/CD pipeline with minimal overhead
- Strong integration with Terraform, container tooling, and AWS
- Secure authentication via GitHub OIDC
- Clear, auditable workflow definitions stored in the repository
- Easy for contributors and reviewers to understand

### Trade‑offs — ADR‑0006
- GitHub Actions minutes incur cost at scale (not an issue for this project)
- Less native integration with AWS compared to CodePipeline
- Requires careful permissions management to avoid overly broad OIDC roles
- Self‑hosted runners add complexity if required in the future

---

## Alternatives Considered

### AWS CodePipeline / CodeBuild
Rejected because:
- More complex to configure and maintain
- Requires additional AWS resources
- Slower iteration cycle compared to GitHub Actions
- Less intuitive for reviewers unfamiliar with AWS‑native CI/CD

### GitLab CI
Rejected because:
- Requires GitLab hosting or SaaS subscription
- Not aligned with GitHub as the source repository

### CircleCI
Rejected because:
- Additional external dependency
- No meaningful advantage over GitHub Actions for this project

### Jenkins
Rejected because:
- Requires full server management
- High operational overhead
- Not aligned with modern cloud‑native CI/CD practices

---

GitHub Actions provides a secure, maintainable, and industry‑standard CI/CD foundation that integrates cleanly with Terraform, container tooling, and AWS, supporting the project’s DevSecOps and automation goals.
