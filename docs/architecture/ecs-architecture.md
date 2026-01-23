# ECS Architecture

The FastAPI service is deployed on Amazon ECS using Fargate, providing a fully managed, serverless
container runtime.  
This architecture balances simplicity, security, and operational clarity.

---

## High‑Level Components

### 1. ECS Cluster

A logical grouping of Fargate tasks.  
No EC2 instances are managed directly.

### 2. Task Definition

Defines:

- Container image (from ECR)
- CPU and memory allocation
- Environment variables
- Logging configuration
- IAM task role

### 3. ECS Service

Ensures:

- Desired number of tasks are running
- Rolling deployments occur safely
- Tasks are registered with the load balancer

### 4. Application Load Balancer (ALB)

Provides:

- Public entry point
- Path‑based routing (if needed)
- Health checks
- TLS termination (optional future enhancement)

---

## Networking Model

- Tasks run in **private subnets**
- ALB resides in **public subnets**
- Security groups enforce least‑privilege ingress/egress
- No direct public access to ECS tasks

This aligns with AWS best practices for containerised workloads.

---

## IAM Roles

### Task Execution Role

Allows ECS to:

- Pull images from ECR
- Write logs to CloudWatch

### Task Role

Grants the application only the permissions it needs.  
Initially minimal, expanded only if required.

---

## Deployment Flow

1. CI/CD pipeline builds and scans the container image
2. Image pushed to ECR
3. Terraform updates the ECS service
4. ECS performs a rolling deployment
5. ALB health checks ensure only healthy tasks receive traffic

---

## Observability

- CloudWatch Logs for application output
- CloudWatch metrics for ECS service health
- ALB metrics for request volume and latency
- EventBridge alerts for task failures (future enhancement)

---

This ECS architecture provides a secure, scalable, and maintainable foundation for the FastAPI
microservice.
