# ADR‑0016: Resilience & Recovery Strategy

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform is a stateless FastAPI service deployed on AWS ECS Fargate behind an Application Load Balancer. It runs in private subnets across multiple Availability Zones within a single AWS region (ap-southeast-1). The architecture is intentionally minimal and cost‑efficient, but it must still demonstrate a clear approach to resilience and recovery, particularly in the context of MAS Technology Risk Management (TRM) expectations.

MAS TRM emphasises:

- service availability and continuity  
- resilience against infrastructure failures  
- clear recovery objectives (RTO/RPO)  
- the ability to restore services in a controlled and predictable manner  
- understanding of cloud provider resilience capabilities  

Although this project is not a regulated financial workload, documenting resilience and recovery decisions ensures the architecture remains transparent, defensible, and extensible for MAS‑aligned environments.

---

## Decision

The platform will adopt a **stateless, multi‑AZ, single‑region resilience model** with the following characteristics:

- No persistence layer is used; therefore, **RPO = 0** by design.  
- ECS Fargate tasks run across multiple Availability Zones for baseline resilience.  
- Rolling deployments ensure continuity during application updates.  
- Recovery is achieved through **redeployment from source** using Terraform and CI/CD.  
- Multi‑region failover is not implemented but remains a future extension point.  

This approach provides strong resilience for a stateless service while keeping the architecture simple and cost‑efficient.

---

## Rationale

### Stateless Architecture
- With no database or durable storage, the application can be recreated at any time without data loss.  
- Eliminates the need for backup, replication, or snapshot strategies.  
- Simplifies recovery and reduces operational overhead.

### Multi‑AZ Deployment
- ECS Fargate tasks are distributed across multiple Availability Zones.  
- ALB automatically routes traffic to healthy tasks.  
- Provides resilience against AZ‑level failures, aligning with MAS TRM expectations for availability.

### Infrastructure as Code Recovery
- Terraform defines all infrastructure components.  
- Recovery involves re‑applying Terraform and redeploying the application.  
- Ensures predictable, repeatable restoration of the environment.

### CI/CD‑Driven Application Recovery
- GitHub Actions can redeploy the application from source at any time.  
- No manual steps are required once the environment is bootstrapped.  
- Supports rapid restoration in the event of corruption or misconfiguration.

### Cost‑Aligned Design
- Multi‑region redundancy is not implemented due to cost and complexity.  
- MAS TRM does not mandate multi‑region for non‑critical workloads.  
- The architecture remains extensible if future requirements change.

---

## Consequences

### Benefits — ADR‑0016
- Clear, MAS‑aligned resilience posture for a stateless service  
- Multi‑AZ deployment provides strong baseline availability  
- Recovery is simple, fast, and fully automated  
- No backup or replication overhead  
- Architecture remains cost‑efficient and easy to maintain  

### Trade‑offs — ADR‑0016
- No multi‑region failover or disaster recovery capability  
- Recovery depends on Terraform and CI/CD availability  
- Stateful features cannot be added without revisiting this ADR  
- Regulated workloads may require enhanced resilience controls  

---

## Alternatives Considered

### Multi‑Region Active‑Active or Active‑Passive
Rejected because:
- Significantly increases cost and complexity  
- Not required for a stateless reference implementation  
- Would require global routing, replicated secrets, and cross‑region infrastructure  

### Adding a Persistence Layer with Backups
Rejected because:
- The application does not require durable state  
- Would introduce backup, replication, and recovery requirements  
- Conflicts with the project’s stateless design goals  

### Using Self‑Managed Compute for Greater Control
Rejected because:
- ECS Fargate provides stronger resilience with less operational burden  
- Self‑managed compute increases maintenance and failure risk  
- Not aligned with MAS TRM’s preference for well‑governed managed services  

---

This resilience and recovery strategy provides a clear, MAS‑aligned foundation for availability and operational continuity while maintaining the simplicity and stateless nature of the platform. Future enhancements, such as multi‑region failover or stateful components, can be introduced through additional ADRs as the architecture evolves.
