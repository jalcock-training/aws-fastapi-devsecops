# ADR‑0005: Networking Model (ALB + Private ECS Tasks)

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform requires a secure, maintainable, and industry‑standard networking model for exposing a containerised FastAPI service to the internet while keeping application workloads isolated from direct public access.

The networking design must:

- follow AWS best practices for microservices
- minimise the attack surface
- integrate cleanly with ECS Fargate
- support TLS termination
- provide health checks and routing
- scale predictably
- work with CI/CD and infrastructure automation

AWS offers several patterns for exposing services:

1. Public Application Load Balancer (ALB) → private ECS tasks  
2. API Gateway → Lambda or private ALB  
3. Public ECS tasks with public IPs  
4. NLB with TCP/UDP routing  
5. CloudFront → ALB → ECS tasks  

The chosen model must balance security, simplicity, and alignment with common AWS architectures.

---

## Decision

**The platform will use a public Application Load Balancer (ALB) in public subnets, routing traffic to ECS Fargate tasks running in private subnets.**

This pattern provides secure ingress, controlled exposure, and strong alignment with AWS reference architectures.

---

## Rationale

### Security
- ECS tasks run in private subnets with no public IPs
- Only the ALB is internet‑facing
- Security groups strictly control inbound and outbound traffic
- Reduces exposure of application workloads
- Supports future enhancements such as WAF or CloudFront

### Operational Clarity
- ALB provides built‑in health checks, routing, and monitoring
- ECS integrates natively with ALB target groups
- Simplifies blue/green or rolling deployments
- Clear separation between ingress and compute layers

### Industry Alignment
- This is the most widely adopted pattern for containerised microservices on AWS
- Matches AWS Well‑Architected guidance for public‑facing services
- Familiar to reviewers and hiring managers
- Scales cleanly to multi‑service or multi‑environment setups

### Flexibility
- Supports path‑based or host‑based routing if additional services are added
- Can be fronted by CloudFront later without architectural changes
- Works with both IPv4 and IPv6 if required

### Cost and Simplicity
- ALB pricing is predictable and appropriate for a single microservice
- Avoids the complexity of API Gateway + VPC Link
- No need for NAT Gateway for inbound traffic

---

## Consequences

### Benefits — ADR‑0005
- Strong security posture with private workloads
- Clean integration with ECS Fargate and Terraform
- Predictable routing and health‑check behaviour
- Easy to extend with WAF, CloudFront, or additional services
- Aligns with common AWS microservice architectures

### Trade‑offs — ADR‑0005
- ALB introduces a fixed monthly cost even at low traffic
- Not as feature‑rich as API Gateway for request transformation or authentication
- Requires NAT Gateway if tasks need outbound internet access (e.g., for updates)
- Slightly more infrastructure than a pure serverless (Lambda) approach

---

## Alternatives Considered

### API Gateway → Lambda
Rejected because:
- Not aligned with container‑based workloads
- Requires additional frameworks for FastAPI
- Harder to demonstrate container scanning and DevSecOps patterns

### Public ECS Tasks
Rejected because:
- Exposes workloads directly to the internet
- Increases attack surface
- Not aligned with AWS best practices for production workloads

### NLB
Rejected because:
- Lacks HTTP‑level routing and health checks
- Not suitable for FastAPI without additional components

### CloudFront → ALB → ECS
Deferred because:
- Adds cost and complexity not required at this stage
- Can be added later without redesigning the network

---

This networking model provides a secure, maintainable, and industry‑standard foundation for exposing the FastAPI service while keeping application workloads isolated and protected.
