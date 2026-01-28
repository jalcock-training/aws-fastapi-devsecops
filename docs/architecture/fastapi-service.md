# FastAPI Service Architecture

The FastAPI microservice is the core application workload deployed on the AWS platform. It is
intentionally lightweight to keep the focus on DevSecOps, infrastructure, and security practices.

---

## Purpose

The service provides a minimal but realistic API with two endpoints:

- `/health` — returns a simple status payload for load balancer health checks
- `/process` — accepts JSON input and returns a transformed response

This mirrors the structure of a typical internal microservice used for data transformation,
validation, or lightweight business logic.

---

## Application Structure

app/ ├── src/ │ ├── main.py │ ├── api/ │ │ └── routes.py │ ├── models/ │ │ ├── request.py │ │ └──
response.py │ ├── core/ │ │ └── config.py ├── tests/ ├── requirements.txt └── Dockerfile

### Key Design Choices

- **FastAPI** chosen for its speed, clarity, and built‑in validation
- **Pydantic models** enforce strict request/response schemas
- **Structured logging** for CloudWatch compatibility
- **Stateless design** to support horizontal scaling on ECS Fargate
- **Containerised** for reproducibility and security scanning

---

## Deployment Model

The service is packaged as a Docker image and deployed to:

- Amazon ECR (image registry)
- Amazon ECS Fargate (compute)
- Application Load Balancer (ingress)

Traffic flows through the ALB → ECS service → FastAPI container.

---

## Security Considerations

- No secrets baked into the image
- IAM task role provides least‑privilege access
- Container scanning performed in CI/CD
- Dependencies scanned with pip‑audit
- SAST scanning with Bandit

---

## Observability

- Application logs sent to CloudWatch Logs
- ALB access logs stored in S3 (optional)
- Metrics available via ECS and ALB
- Health checks monitored by ALB and ECS

---

This service acts as the “workload under test” for the broader DevSecOps platform.
