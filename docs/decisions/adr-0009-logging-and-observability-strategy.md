# ADR‑0009: Logging and Observability Strategy

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform requires a clear, minimal, and maintainable logging and observability strategy suitable for a single‑service ECS Fargate environment. The solution must support:

- application logs from the FastAPI service
- container runtime logs
- ECS service and task‑level diagnostics
- infrastructure logs from AWS services such as ALB and VPC Flow Logs (if enabled)
- integration with GitHub Actions for build and deployment visibility
- low operational overhead
- predictable cost

Full observability platforms such as Datadog, New Relic, or OpenTelemetry collectors are unnecessary for this project and would introduce cost and complexity. The strategy must remain aligned with AWS best practices while staying lightweight and easy to maintain.

---

## Decision

The platform will use AWS CloudWatch Logs as the central logging destination for application, container, and infrastructure logs. ECS Fargate tasks will send stdout and stderr to CloudWatch using the awslogs log driver. ALB access logs and other optional infrastructure logs may be enabled selectively based on cost and need.

Metrics and alarms will rely on native AWS CloudWatch metrics, with optional custom application metrics added later if required.

This approach provides a simple, reliable, and cost‑effective observability baseline without introducing external dependencies.

---

## Rationale

### Simplicity and Maintainability
- CloudWatch Logs integrates natively with ECS Fargate
- No agents or sidecars are required
- Log groups and retention policies can be fully managed through Terraform
- Developers can view logs directly in the AWS console without additional tooling

### Cost Control
- CloudWatch Logs charges based on ingestion and storage, both of which are minimal for a low‑traffic development environment
- Retention policies prevent unbounded log growth
- Optional logs (ALB access logs, VPC Flow Logs) can be enabled only when needed

### Operational Clarity
- ECS task logs provide visibility into application behaviour
- ALB access logs support debugging of routing or client issues
- CloudWatch metrics provide insight into CPU, memory, and request patterns
- GitHub Actions logs provide build and deployment visibility

### Alignment With AWS Best Practices
- CloudWatch is the default logging backend for ECS Fargate
- No additional infrastructure is required
- Supports future enhancements such as CloudWatch Alarms, dashboards, or metric filters

---

## Consequences

### Benefits — ADR‑0009
- Simple, reliable logging with minimal configuration
- No external services or agents required
- Predictable and low cost for a development environment
- Clear visibility into application and ECS behaviour
- Easy integration with Terraform and GitHub Actions

### Trade‑offs — ADR‑0009
- CloudWatch Logs is less feature‑rich than dedicated observability platforms
- Log search and filtering are functional but not as powerful as third‑party tools
- No distributed tracing or advanced metrics without additional components
- ALB access logs and VPC Flow Logs may increase cost if enabled continuously

---

## Alternatives Considered

### Full Observability Stack (Datadog, New Relic, OpenTelemetry)
Rejected because:
- Adds significant cost and operational overhead
- Requires agents, collectors, or sidecars
- Not necessary for a single‑service development environment

### Self‑Hosted ELK Stack
Rejected because:
- Requires substantial infrastructure and maintenance
- Not aligned with the project’s simplicity and cost goals

### Logging to S3 Only
Rejected because:
- S3 is suitable for archival, not real‑time debugging
- No native log streaming or filtering capabilities

---

This logging and observability strategy provides a lightweight, maintainable, and cost‑effective foundation that supports development and debugging while avoiding unnecessary complexity. It aligns with AWS best practices and leaves room for future enhancements if the platform evolves.
