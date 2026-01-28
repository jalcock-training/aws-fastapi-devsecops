# ADR‑0008: Cost Controls Strategy

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform runs in an AWS account used for development, experimentation, and portfolio
demonstration. To avoid unnecessary spend, the environment must remain cost‑efficient, predictable,
and safe from unexpected charges.

Two AWS services dominate baseline cost in a VPC‑based ECS architecture:

- **NAT Gateway** (~$45/month in ap-southeast-2)
- **Application Load Balancer (ALB)** (~$22/month)

These services incur hourly charges even when idle. All other components (ECS tasks, ECR, S3, IAM,
CloudWatch) are either free‑tier‑eligible or usage‑based.

Because the environment does not need to run 24/7, the cost‑control strategy must include both
**monitoring** and **intentional shutdown of non-essential infrastructure**.

---

## Decision

**The platform will use a layered cost‑control strategy combining AWS Budgets, Cost Anomaly
Detection, and an environment toggle mechanism that disables NAT Gateway, ALB, and ECS compute when
not in active use.**

This strategy includes:

- a monthly AWS Budget with alert thresholds
- Cost Anomaly Detection for unexpected spikes
- tagging standards for cost attribution
- Terraform automation to ensure predictable resource creation
- a toggle variable to enable/disable compute and networking resources
- selective use of free‑tier‑eligible services where appropriate

When the environment is idle, NAT Gateway, ALB, and ECS services will be destroyed to reduce
baseline cost to near zero.

---

## Rationale

### Cost Visibility and Governance

- AWS Budgets provides predictable monthly thresholds
- Alerts notify the developer before costs exceed expectations
- Cost Explorer supports periodic review of usage patterns
- Tagging enables future cost allocation if additional services are added

### Major Cost Reduction Through Environment Toggling

The most effective cost control is **not running expensive resources when they are not needed**.

A Terraform variable such as:

```hcl
variable "enable_compute" {
  type    = bool
  default = false
}
```

This reduces monthly cost from approximately $67–70 down to $0–5.

### Alignment With Industry Practice

- Ephemeral or on‑demand development environments are widely used to control spend
- Terraform‑driven toggling is simple, predictable, and easy to automate
- Matches patterns used by platform teams managing multiple dev/test environments

### Operational Simplicity

- No external tools or SaaS dependencies
- Alerts delivered via email
- Environment can be recreated in minutes
- Terraform ensures consistent, repeatable provisioning

---

## Consequences

### Benefits — ADR‑0008

- Reduces monthly AWS cost from roughly $70 to $0–5 when idle
- Strong guardrails against unexpected charges
- Predictable, controlled cost profile suitable for ongoing development
- Terraform automation reduces risk of manual misconfiguration
- Aligns with modern cloud governance and ephemeral environment practices

### Trade‑offs — ADR‑0008

- Environment recreation takes 5–10 minutes
- NAT Gateway and ALB must be re‑provisioned before testing
- CI/CD pipelines must account for the environment being “off”
- Tagging discipline must be maintained across future resources

---

## Alternatives Considered

### Always‑on Environment

Rejected because it incurs a baseline cost of approximately $67–70 per month and provides no benefit
when the environment is not actively being used.

### NAT‑less Architecture

Rejected because ECS tasks in private subnets require outbound internet for image pulls and updates.
Replacing NAT with VPC endpoints for all required services adds complexity and cost.

### Relying Solely on AWS Free Tier

Rejected because the Free Tier does not cover NAT Gateway or ALB, and usage patterns may exceed
free‑tier limits.

### Third‑party Cost Management Tools

Rejected because they add unnecessary complexity and cost. AWS‑native tools provide sufficient
coverage for this environment.

---

This strategy provides a practical, maintainable, and industry‑aligned approach to managing AWS
spend. By combining monitoring with intentional environment toggling, the platform remains
cost‑efficient while still supporting full‑featured development and testing workflows.
