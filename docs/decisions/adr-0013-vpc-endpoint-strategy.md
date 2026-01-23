# ADR‑0013: VPC Endpoint Strategy

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform runs inside a private VPC with ECS Fargate tasks deployed in private subnets. These
tasks require access to several AWS services, including ECR, CloudWatch Logs, and S3. By default,
this outbound traffic flows through the NAT Gateway, which incurs a significant baseline cost.

VPC Endpoints (AWS PrivateLink) allow private connectivity to AWS services without traversing the
NAT Gateway. They can reduce NAT data processing charges and improve security by keeping traffic
within the AWS network. However, each endpoint introduces an hourly cost, and some endpoints (such
as interface endpoints) can be more expensive than the NAT traffic they replace.

The endpoint strategy must balance cost, security, and operational simplicity.

---

## Decision

The platform will not use VPC Endpoints by default. NAT Gateway will remain the primary path for
outbound traffic from ECS tasks. VPC Endpoints may be added later only if the environment becomes
long‑running or if specific services require private connectivity.

This approach avoids unnecessary baseline cost while keeping the architecture simple and flexible.

---

## Rationale

### Cost Considerations

- Interface VPC Endpoints incur hourly charges that can exceed NAT Gateway data costs in a
  low‑traffic development environment.
- The environment is not intended to run 24/7; NAT Gateway and ALB are disabled when idle.
- Adding endpoints would increase baseline cost even when the environment is turned off.

### Simplicity

- NAT Gateway provides universal outbound access without managing multiple endpoints.
- No need to maintain endpoint policies, DNS settings, or additional Terraform modules.
- Reduces cognitive load for contributors and reviewers.

### Security

- ECS tasks run in private subnets and do not expose public IPs.
- IAM roles restrict access to AWS services regardless of network path.
- For a development environment, NAT‑based egress is sufficient.

### Flexibility

- The architecture remains endpoint‑ready if future requirements change.
- Endpoints can be added selectively (e.g., S3, ECR, Logs) if the environment becomes long‑running
  or if NAT costs increase.
- No architectural changes are required to introduce endpoints later.

---

## Consequences

### Benefits — ADR‑0013

- Zero additional baseline cost from VPC Endpoints
- Simpler Terraform configuration and fewer moving parts
- NAT Gateway remains the single egress point for outbound traffic
- Architecture remains flexible for future endpoint adoption
- Aligns with the environment‑toggle cost‑control strategy

### Trade‑offs — ADR‑0013

- ECS tasks rely on NAT Gateway for all outbound traffic
- Slightly higher data processing cost during active use
- No private connectivity to AWS services unless endpoints are added later
- Future endpoint adoption will require additional Terraform modules

---

## Alternatives Considered

### Adding S3 and ECR Endpoints

Rejected because:

- Interface endpoints incur hourly charges that exceed expected NAT data usage
- The environment is not long‑running enough to justify the cost

### Adding CloudWatch Logs Endpoint

Rejected because:

- Logs ingestion volume is low
- Endpoint cost outweighs potential NAT savings

### Full Endpoint Coverage (S3, ECR, Logs, STS)

Rejected because:

- Would significantly increase baseline cost
- Adds operational complexity without meaningful benefit for a development environment

---

This VPC Endpoint strategy keeps the environment cost‑efficient, simple, and aligned with the
toggle‑based architecture. Endpoints can be introduced later if the platform evolves into a
long‑running or production‑grade system.
