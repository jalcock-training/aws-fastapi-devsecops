# ADR‑0007: Security Scanning Toolchain

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform requires a security scanning toolchain that supports:

- scanning Python dependencies for known vulnerabilities
- static analysis of application code
- container image vulnerability scanning
- Infrastructure‑as‑Code (IaC) scanning for Terraform
- integration with GitHub Actions
- alignment with modern DevSecOps practices
- minimal operational overhead

The scanning tools must be:

- open‑source or low‑cost
- widely adopted in industry
- easy to automate in CI/CD
- compatible with local development workflows

Several categories of scanning are required:

1. **Software Composition Analysis (SCA)**
2. **Static Application Security Testing (SAST)**
3. **Container image scanning**
4. **Infrastructure‑as‑Code scanning**

Multiple tools exist in each category, including commercial platforms, but the project prioritises
simplicity, transparency, and industry‑standard open‑source tooling.

---

## Decision

**The platform will use the following security scanning tools:**

- **pip‑audit** for Python dependency vulnerability scanning
- **Bandit** for Python static analysis
- **Trivy** for container image scanning
- **Checkov** for Terraform IaC scanning

These tools will run locally and in GitHub Actions as part of the CI pipeline.

---

## Rationale

### Coverage Across Security Domains

The selected tools collectively cover all major DevSecOps scanning categories:

- **pip‑audit** → SCA for Python packages
- **Bandit** → SAST for Python code
- **Trivy** → container image scanning
- **Checkov** → Terraform IaC scanning

This ensures comprehensive security checks across the entire stack.

### Industry Alignment

- All selected tools are widely used across cloud and platform engineering teams
- Strong community support and active maintenance
- Familiar to reviewers and hiring managers
- Align with common AWS and GitHub Actions workflows

### Integration and Automation

- All tools run cleanly in GitHub Actions
- No external services or credentials required
- Simple local execution for developers
- Clear, actionable output suitable for CI gating

### Cost and Simplicity

- Fully open‑source
- No licensing or SaaS dependencies
- Minimal configuration required
- Easy to maintain as the project evolves

---

## Consequences

### Benefits — ADR‑0007

- Comprehensive security coverage across dependencies, code, containers, and IaC
- Fully automated scanning in CI/CD
- No reliance on external SaaS platforms
- Easy for contributors to run scans locally
- Clear, industry‑standard DevSecOps posture

### Trade‑offs — ADR‑0007

- Open‑source scanners may lack some advanced features found in commercial tools
- Requires maintaining multiple tools rather than a single unified platform
- False positives may require tuning over time
- Container scanning increases CI runtime slightly

---

## Alternatives Considered

### Snyk

Rejected because:

- Requires SaaS integration and account setup
- Adds external dependencies not needed for this project
- Paid tiers required for full functionality

### AWS CodeGuru / Amazon Inspector

Rejected because:

- Inspector focuses on EC2/ECR scanning but adds cost and configuration overhead
- CodeGuru is not aligned with Python FastAPI workloads

### SonarQube

Rejected because:

- Requires hosting or paid SaaS
- More complex than necessary for a single‑service platform

### tfsec (standalone)

Not applicable:

- tfsec has been fully merged into Trivy and is no longer maintained as a separate tool

---

This toolchain provides a clear, maintainable, and industry‑aligned security foundation that
integrates seamlessly with GitHub Actions and supports the project’s DevSecOps objectives.
