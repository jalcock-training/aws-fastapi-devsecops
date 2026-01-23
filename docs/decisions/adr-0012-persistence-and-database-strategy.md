# ADR‑0012: Persistence and Database Strategy

## Status

Accepted

## Date

2026‑01‑23

## Context

The current platform is a single‑service FastAPI application deployed on ECS Fargate. The service
does not require durable state, relational data, or long‑term storage. All existing functionality is
fully stateless, and the application can be scaled, restarted, or redeployed without data loss.

Introducing a database at this stage would add cost, operational overhead, and security
considerations without providing meaningful value. However, the architecture should remain flexible
enough to support persistence in the future if the application evolves to require it.

AWS provides several persistence options, including DynamoDB, RDS, Aurora Serverless, S3, and
ElastiCache. Each option introduces different trade‑offs in terms of cost, complexity, and
operational burden.

---

## Decision

The platform will remain **stateless** and will not include a database or persistence layer at this
stage. All application logic will operate without durable storage, and no state will be written to
disk or external systems.

If persistence is required in the future, DynamoDB or Aurora Serverless v2 will be evaluated as the
primary candidates, depending on the data model and access patterns.

---

## Rationale

### Simplicity and Maintainability

- A stateless service is easier to deploy, scale, and operate
- No need to manage backups, migrations, or schema changes
- No additional AWS services or Terraform modules required
- Reduces cognitive load for contributors and reviewers

### Cost Efficiency

- Avoids the baseline cost of RDS or Aurora Serverless
- Avoids DynamoDB read/write charges for unused tables
- Keeps the environment lightweight and inexpensive

### Architectural Flexibility

- Stateless design aligns with container‑based microservices
- Future persistence can be added without breaking existing patterns
- ECS Fargate and ALB do not require a database to operate

### Security

- No database credentials or connection strings required
- Reduces the secrets footprint and IAM complexity
- Minimises attack surface for early development stages

---

## Consequences

### Benefits — ADR‑0012

- Zero cost for persistence during early development
- Simplified infrastructure and Terraform configuration
- No database administration or operational burden
- Clean, stateless service ideal for a portfolio project
- Easy to extend later if persistence becomes necessary

### Trade‑offs — ADR‑0012

- Application cannot store user data or long‑term state
- Features requiring persistence must be deferred or redesigned
- Future introduction of a database will require new ADRs and Terraform modules

---

## Alternatives Considered

### DynamoDB

Rejected for now because:

- No current need for key‑value or document storage
- Would introduce cost and IAM complexity without immediate benefit

### RDS / Aurora Serverless

Rejected because:

- Overkill for a stateless service
- Higher baseline cost and operational overhead
- Requires VPC networking, security groups, and connection management

### S3‑based Storage

Rejected because:

- Not required for the current application
- Would introduce unnecessary IAM and lifecycle policies

### Embedding SQLite in the Container

Rejected because:

- Breaks statelessness
- Not suitable for ECS Fargate
- No persistence across task restarts

---

This decision keeps the platform intentionally stateless, cost‑efficient, and easy to operate while
preserving the option to introduce persistence later through a dedicated ADR and Terraform module.
