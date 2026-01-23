# ADR‑0015: Third‑Party & Cloud Provider Risk Considerations

## Status
Accepted

## Date
2026‑01‑23

## Context

The platform is deployed entirely on AWS and relies on several managed services, including ECS Fargate, ECR, CloudWatch, IAM, and S3. These services constitute third‑party dependencies under the MAS Technology Risk Management (TRM) framework, which requires financial institutions to assess and manage risks arising from outsourced service providers and cloud environments.

Although this project is a reference implementation and not a regulated financial workload, it is designed with MAS‑aligned principles in mind. Documenting third‑party and cloud‑provider considerations ensures the architecture remains transparent, secure, and extensible for organisations operating under MAS TRM expectations.

Key MAS TRM themes relevant to this decision include:

- understanding the shared responsibility model  
- ensuring service availability and resilience  
- managing vendor lock‑in and portability  
- assessing security controls provided by the cloud provider  
- ensuring data protection and access governance  

---

## Decision

The platform will rely on AWS as the primary cloud service provider and will explicitly adopt AWS’s shared responsibility model. AWS is responsible for the security *of* the cloud, while the platform is responsible for the security *in* the cloud.

The architecture will be designed to:

- minimise unnecessary third‑party dependencies  
- use AWS managed services where they provide clear security and operational benefits  
- document all external dependencies and their roles  
- ensure that all data, access, and operational controls remain under the platform’s governance  

This approach provides a clear, MAS‑aligned foundation for managing third‑party and cloud‑provider risks.

---

## Rationale

### Alignment with MAS TRM Expectations
- MAS TRM emphasises governance, transparency, and understanding of outsourced dependencies.  
- AWS provides audited, well‑documented controls that align with MAS TRM requirements.  
- Using managed services reduces operational risk and simplifies compliance.

### Security and Operational Benefits
- AWS managed services (ECS, ECR, CloudWatch, IAM) provide strong defaults and reduce the attack surface.  
- The platform retains full control over IAM, network boundaries, encryption, and deployment workflows.  
- No long‑lived credentials are stored in CI/CD or application code.

### Reduced Vendor Complexity
- The architecture avoids unnecessary third‑party SaaS tools.  
- All critical components (compute, registry, logging, secrets, networking) remain within AWS.  
- This reduces integration risk and simplifies governance.

### Portability Considerations
- The application and infrastructure are defined using Terraform and containers, enabling portability to other cloud providers if required.  
- No AWS‑specific application code is used.  
- Migration effort would be focused on infrastructure modules, not the application itself.

---

## Consequences

### Benefits — ADR‑0015
- Clear understanding of third‑party dependencies and their roles  
- Strong alignment with MAS TRM expectations for cloud usage  
- Reduced operational and integration risk  
- Simplified governance and auditability  
- Portability preserved through containerisation and IaC  

### Trade‑offs — ADR‑0015
- Reliance on AWS managed services introduces a degree of vendor lock‑in  
- Migration to another cloud provider would require re‑implementing infrastructure modules  
- MAS‑grade compliance would require additional controls (e.g., multi‑region resilience, enhanced monitoring) if adopted by a regulated FI  

---

## Alternatives Considered

### Multi‑Cloud or Cloud‑Agnostic Architecture
Rejected because:
- Adds significant complexity without meaningful benefit for this project  
- Increases operational overhead and reduces clarity  
- Not aligned with the goal of a minimal, focused reference implementation  

### Using Third‑Party SaaS Tools for CI/CD, Logging, or Secrets
Rejected because:
- Introduces additional vendor risk  
- Increases integration and compliance complexity  
- AWS native services provide sufficient capability  

### Self‑Hosted Components
Rejected because:
- Increases operational burden  
- Reduces security and resilience compared to managed services  
- Not aligned with MAS TRM’s preference for well‑governed, resilient cloud services  

---

This decision ensures that third‑party and cloud‑provider risks are clearly understood, documented, and managed in a way that aligns with MAS TRM principles while keeping the architecture simple, secure, and maintainable.
