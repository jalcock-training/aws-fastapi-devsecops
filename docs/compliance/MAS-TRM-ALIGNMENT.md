# MAS TRM Alignment Summary

This document provides a high‑level mapping of the platform’s architecture, controls, and design
decisions to the key domains of the Monetary Authority of Singapore (MAS) Technology Risk Management
(TRM) Guidelines. It is not a certification document, but a clear demonstration of how the project
aligns with MAS‑style expectations for secure, well‑governed cloud workloads.

---

## 1. Technology Risk Governance

**Relevant ADRs:**

- ADR‑0001 — Repository Structure
- ADR‑0015 — Third‑Party & Cloud Provider Risk Considerations
- ADR‑0018 — Change Management & Deployment Governance

**Alignment Summary:**

- Architectural decisions are documented using ADRs, providing traceability and governance.
- Clear separation of concerns across application, infrastructure, CI/CD, and documentation.
- All changes flow through Pull Requests with review and CI validation.
- No manual changes are made in the AWS console, ensuring controlled governance.

---

## 2. System Security Design

**Relevant ADRs:**

- ADR‑0004 — Infrastructure Platform
- ADR‑0014 — IAM & Access Control Model
- ADR‑0011 — Secrets Management
- ADR‑0017 — Monitoring & Security Operations

**Alignment Summary:**

- Least‑privilege IAM roles for ECS tasks, CI/CD, and infrastructure provisioning.
- No long‑lived AWS credentials; GitHub Actions uses OIDC.
- Secrets stored in Parameter Store as SecureString values.
- Network isolation via private subnets and ALB‑fronted ingress.
- CloudTrail, EventBridge, and CloudWatch provide auditability and security visibility.

---

## 3. Access Control

**Relevant ADRs:**

- ADR‑0014 — IAM & Access Control Model
- ADR‑0011 — Secrets Management

**Alignment Summary:**

- IAM roles are scoped to the minimum required permissions.
- No static credentials in code, CI/CD, or Terraform.
- Application tasks run with dedicated task roles.
- CI/CD uses short‑lived, identity‑federated credentials.
- Secrets are encrypted and centrally managed.

---

## 4. Data Protection & Cryptography

**Relevant ADRs:**

- ADR‑0011 — Secrets Management
- ADR‑0015 — Third‑Party & Cloud Provider Risk Considerations

**Alignment Summary:**

- No customer data is stored; the service is fully stateless.
- Parameter Store SecureString values provide encrypted secret storage.
- Optional KMS integration is supported for enhanced encryption needs.
- No data persistence means no backup or data‑at‑rest risk exposure.

---

## 5. Logging, Monitoring & Auditability

**Relevant ADRs:**

- ADR‑0017 — Monitoring, Alerting & Security Operations

**Alignment Summary:**

- CloudTrail enabled for API activity logging.
- ECS task logs captured in CloudWatch Logs.
- ALB access logs provide request‑level visibility.
- EventBridge rules detect high‑risk events (e.g., root login).
- SNS notifications provide alerting for operational and security events.

---

## 6. IT Service Continuity & Resilience

**Relevant ADRs:**

- ADR‑0016 — Resilience & Recovery Strategy

**Alignment Summary:**

- Stateless architecture ensures RPO = 0.
- Multi‑AZ ECS Fargate deployment provides baseline resilience.
- Rolling deployments ensure continuity during updates.
- Recovery is deterministic via Terraform and CI/CD.
- Multi‑region failover is not implemented but remains an extension point.

---

## 7. Change Management

**Relevant ADRs:**

- ADR‑0018 — Change Management & Deployment Governance

**Alignment Summary:**

- All changes require Pull Requests and review.
- Terraform plans must be reviewed before merging.
- CI/CD enforces validation and automated deployment.
- Rollbacks are performed via Git revert and redeployment.
- No console‑driven or ad‑hoc changes.

---

## 8. Third‑Party & Cloud Provider Risk

**Relevant ADRs:**

- ADR‑0015 — Third‑Party & Cloud Provider Risk Considerations

**Alignment Summary:**

- AWS is the sole cloud provider; dependencies are documented.
- Architecture follows AWS shared responsibility model.
- No unnecessary third‑party SaaS tools are used.
- Infrastructure and application remain portable via Terraform and containers.

---

## 9. Incident Response Readiness

**Relevant ADRs:**

- ADR‑0017 — Monitoring, Alerting & Security Operations

**Alignment Summary:**

- High‑risk events generate alerts via SNS.
- CloudTrail provides audit logs for investigation.
- Logs and metrics support detection and triage.
- Stateless design simplifies recovery actions.
- Incident response processes can be extended for regulated workloads.

---

## 10. Summary

This project demonstrates strong alignment with MAS TRM principles across governance, security,
resilience, monitoring, and change management. While not a regulated workload, the architecture and
documentation reflect the expectations of Singapore fintechs and financial institutions, and provide
a solid foundation for future MAS‑grade enhancements if required.
