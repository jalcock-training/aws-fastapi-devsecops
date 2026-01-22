# ADR‑0004: Compute Platform Choice (ECS Fargate)

## Status

Accepted

## Date

2026‑01‑23

## Context

The platform requires a compute environment capable of running a containerised FastAPI microservice
with strong security, predictable operational behaviour, and minimal infrastructure management
overhead. The compute platform must:

- integrate cleanly with AWS networking and IAM
- support automated deployments through CI/CD
- align with modern cloud engineering practices
- avoid unnecessary operational burden
- scale appropriately for a single‑service architecture
- demonstrate industry‑standard patterns for containerised workloads

AWS provides several options for running containers or application workloads:

1. Amazon ECS on Fargate (serverless containers)
2. Amazon ECS on EC2 (self‑managed container hosts)
3. Amazon EKS (Kubernetes)
4. AWS Lambda (serverless functions)
5. EC2 instances (fully self‑managed)

The chosen platform must balance capability, maintainability, and clarity for reviewers.

---

## Decision

**Amazon ECS with Fargate is selected as the compute platform for running the FastAPI
microservice.**

This provides a fully managed, serverless container runtime that aligns with widely adopted AWS
architectural patterns.

---

## Rationale

### Security

- No EC2 instances to patch or secure
- Tasks run in isolated compute environments
- IAM task roles enforce least‑privilege access
- Integrates with VPC private subnets and security groups
- Works well with container scanning and DevSecOps workflows

### Operational Efficiency

- No cluster nodes, autoscaling groups, or AMIs to manage
- ECS handles task placement, scaling, and health checks
- Rolling deployments are handled natively by ECS services
- Reduces operational overhead compared to EC2 or Kubernetes

### Cost Alignment

- Pay only for CPU and memory consumed by running tasks
- No idle capacity costs
- Suitable for low‑traffic or moderate‑traffic microservices

### Alignment With Industry Practice

- ECS Fargate is widely used for small to medium‑sized microservices
- Strong integration with AWS networking, IAM, and observability
- Clear, predictable operational model
- Well‑supported by Terraform and GitHub Actions

### Developer Experience

- Straightforward deployment workflow
- Minimal cognitive load for contributors
- Easy for reviewers to understand and evaluate

---

## Alternatives Considered

### ECS on EC2

Rejected because:

- Requires managing EC2 instances, scaling groups, and AMIs
- Higher operational overhead without providing meaningful benefits for this project

### EKS (Kubernetes)

Rejected because:

- Significantly more complex to operate
- Requires cluster management, node groups, add‑ons, and networking layers
- Not aligned with the scope or requirements of a single‑service platform
- Would shift focus away from DevSecOps and into Kubernetes administration

### AWS Lambda

Rejected because:

- Not ideal for containerised FastAPI without additional frameworks
- Less suitable for long‑running or stateful microservices
- Harder to demonstrate container scanning and CI/CD patterns

### EC2 Instances

Rejected because:

- Full responsibility for OS patching, scaling, and security
- Not aligned with modern AWS container practices
- Adds unnecessary operational burden

---

## Consequences

### Positive

- Minimal operational overhead
- Strong security posture
- Predictable deployment and scaling behaviour
- Clean integration with Terraform and CI/CD
- Industry‑standard architecture for containerised workloads

### Negative

- Slightly higher per‑unit cost than EC2 for sustained high‑load workloads
- Less flexibility than Kubernetes for complex multi‑service systems

---

Amazon ECS Fargate provides a secure, maintainable, and industry‑aligned foundation for running the
FastAPI microservice, supporting the project’s focus on DevSecOps, automation, and platform
engineering best practices.
