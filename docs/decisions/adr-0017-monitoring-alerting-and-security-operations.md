# ADR‑0017: Monitoring, Alerting & Security Operations

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform is a stateless FastAPI service deployed on ECS Fargate behind an Application Load Balancer. While the architecture is intentionally minimal, it must still provide sufficient monitoring, observability, and security operations to support operational awareness and align with MAS Technology Risk Management (TRM) expectations.

MAS TRM emphasises:

- continuous monitoring of system health and security events  
- timely detection of anomalies and unauthorised activity  
- audit logging and traceability  
- operational visibility into cloud workloads  
- the ability to respond to incidents effectively  

The platform already includes CloudTrail, EventBridge, and basic logging, but a more explicit monitoring and alerting strategy is required to ensure operational readiness and regulatory alignment.

---

## Decision

The platform will implement a **baseline monitoring and alerting model** using AWS native services. This includes:

- CloudWatch Logs for application and ECS task logs  
- CloudWatch Metrics for ECS, ALB, and infrastructure health  
- CloudWatch Alarms for critical conditions  
- EventBridge rules for security‑relevant events  
- SNS for alert delivery  
- CloudTrail for audit logging  

This model provides sufficient observability for a stateless service while remaining cost‑efficient and easy to maintain.

---

## Rationale

### Alignment with MAS TRM Expectations
- MAS TRM requires continuous monitoring, anomaly detection, and auditability.  
- AWS native services provide strong coverage without additional third‑party tools.  
- Logging and alerting are centralised and immutable.

### Operational Visibility
- ECS task logs are captured in CloudWatch Logs for debugging and analysis.  
- ALB access logs provide visibility into request patterns and errors.  
- CloudWatch metrics track CPU, memory, latency, and error rates.

### Security Monitoring
- CloudTrail records all API activity for audit and investigation.  
- EventBridge rules detect high‑risk events such as root logins or IAM changes.  
- SNS delivers alerts to operators for timely response.

### Cost‑Efficient and Minimal
- No additional SaaS monitoring tools are required.  
- CloudWatch usage remains low for a development‑scale environment.  
- The model can be expanded if the platform evolves into a production workload.

---

## Consequences

### Benefits — ADR‑0017
- Clear, MAS‑aligned monitoring and security operations model  
- Centralised logs and metrics for troubleshooting and analysis  
- Automated detection of high‑risk events  
- Cost‑efficient and easy to maintain  
- Extensible to more advanced observability stacks if needed  

### Trade‑offs — ADR‑0017
- No deep application performance monitoring (APM)  
- No SIEM integration or advanced threat analytics  
- Alerting is basic and may require enhancement for production workloads  
- Incident response processes are minimal and not automated  

---

## Alternatives Considered

### Using Third‑Party Monitoring Tools (Datadog, New Relic, etc.)
Rejected because:
- Adds cost and operational complexity  
- Not required for a stateless reference implementation  
- AWS native tools provide sufficient coverage  

### Building a Full SIEM or Security Operations Pipeline
Rejected because:
- Overkill for the scope of this project  
- Would require significant configuration and ongoing maintenance  
- Not aligned with the goal of a minimal, clear reference architecture  

### No Monitoring or Minimal Logging Only
Rejected because:
- Insufficient for operational awareness  
- Does not align with MAS TRM expectations  
- Reduces the ability to detect and respond to issues  

---

This monitoring and security operations strategy provides a clear, MAS‑aligned foundation for observability and incident detection while keeping the architecture simple, cost‑efficient, and appropriate for a stateless reference implementation.
