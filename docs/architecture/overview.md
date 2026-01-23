# Architecture Overview

This project implements a secure, production‑style deployment of a FastAPI microservice on AWS,
supported by a fully automated DevSecOps pipeline and a hardened cloud foundation. The architecture
is intentionally minimal but reflects real‑world platform engineering practices.

---

## High‑Level Goals

- Provide a reference implementation of a secure AWS application platform
- Demonstrate DevSecOps automation from code to production
- Showcase infrastructure‑as‑code discipline using Terraform
- Deploy a containerised FastAPI microservice using modern AWS services
- Establish strong security, observability, and cost‑control foundations

---

## Core Components

### 1. FastAPI Microservice

A lightweight Python application packaged as a container image.  
It exposes two endpoints:

- `/health` — service health check
- `/process` — simple JSON transformation endpoint

The service is intentionally small to keep the focus on platform engineering and DevSecOps
practices.

---

### 2. DevSecOps Pipeline (GitHub Actions)

The CI/CD pipeline performs:

- Linting and unit tests
- Python dependency scanning (SCA)
- Static analysis (SAST)
- Container image scanning
- Terraform validation and plan
- Build and push to Amazon ECR
- Deployment to ECS Fargate

Security scanning is integrated into every stage to enforce shift‑left principles.

---

### 3. AWS Infrastructure (Terraform)

All infrastructure is defined using Terraform, following a modular structure.

#### Networking

- VPC with public and private subnets
- Optional NAT gateway
- Security groups enforcing least privilege

#### Compute

- ECS cluster (Fargate)
- Task definition and IAM task role
- Application Load Balancer for ingress
- CloudWatch log groups for application logs

#### Observability

- CloudTrail for API auditing
- CloudWatch metrics and dashboards
- EventBridge rules for security and operational alerts
- SNS notifications

#### Cost Controls

- CloudWatch billing alarm
- Cost Anomaly Detection monitor and subscription
- SNS‑based alerting

These controls are established early to prevent unexpected spend.

---

## Deployment Flow

1. Developer pushes code to GitHub
2. CI pipeline runs tests and security scans
3. Docker image is built and pushed to ECR
4. Terraform applies infrastructure changes
5. ECS service is updated with the new image
6. ALB routes traffic to the updated tasks
7. Logs and metrics flow into CloudWatch

This provides a fully automated, repeatable deployment lifecycle.

---

## Security Posture

Security is embedded throughout the architecture:

- IAM Identity Center for authentication
- No long‑lived IAM users or access keys
- Least‑privilege IAM roles for ECS tasks
- Encrypted S3 buckets and ECR repositories
- Security scanning in CI/CD
- CloudTrail and EventBridge for audit and alerting
- Cost controls to detect anomalies early

The goal is to model a realistic, secure cloud environment suitable for production workloads.

---

## Future Enhancements

Potential extensions include:

- Staging environment
- AWS WAF in front of the ALB
- Secrets Manager integration
- Automated dependency updates
- Load testing and performance dashboards

These are optional but demonstrate how the architecture can evolve.

---

This overview provides the conceptual map for the project.  
Detailed components are documented in the corresponding architecture pages.
