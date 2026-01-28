# Setup Guide

This document explains how to bootstrap, deploy, and manage the development environment for the
FastAPI ECS Fargate platform. The environment is intentionally lightweight, cost‑controlled, and
fully reproducible using Terraform.

---

## 1. Prerequisites

Install the following tools locally:

- AWS CLI v2
- Terraform (latest stable version)
- Python 3.11+ (optional for local app testing)
- Docker (for building images locally)
- Git

Ensure your AWS CLI is configured with credentials that have permission to create infrastructure in
your AWS account.

---

## 2. Repository Structure (Summary)

Key directories:

- `infra/` — Terraform configuration for VPC, ECS, ALB, IAM, and supporting services
- `app/` — FastAPI application code
- `ci/` — GitHub Actions workflows
- `docs/` — ADRs and architectural documentation

Refer to ADR‑0001 for full details.

---

## 3. Initial AWS Account Setup

Before running Terraform for the first time:

1. Create an S3 bucket for Terraform state.
2. Create a DynamoDB table for state locking.
3. Update the backend configuration in `infra/backend.tf` with your bucket and table names.

These resources are created once per account.

---

## 4. Bootstrapping Terraform

From the `infra/` directory:

1. Initialize Terraform

   ```bash
   terraform init
   ```

2. Review the plan

   ```bash
   terraform plan
   ```

3. Apply the infrastructure

   ```bash
   terraform apply
   ```

This provisions the VPC, subnets, IAM roles, ECS cluster, and supporting components.

---

## 5. Secrets Setup

Secrets are stored in AWS Systems Manager Parameter Store as SecureString parameters.

You must manually create:

- Application secret key
- Any additional secrets required by the FastAPI service

Refer to ADR‑0011 for the secrets management strategy.

---

## 6. Building and Deploying the Application

### Local build (optional)

```bash
docker build -t fastapi-app .
```

### CI/CD deployment

Push to the `main` branch to trigger GitHub Actions:

- Builds and pushes the container image to ECR
- Updates the ECS task definition
- Performs a rolling deployment

GitHub Actions authenticates using OIDC; no long‑lived AWS credentials are stored.

---

## 7. Environment Toggle (Cost Control)

The environment supports a toggle mode that disables NAT Gateway, ALB, and ECS compute when not in
use.

To enable the environment for testing:

```bash
terraform apply -var="enable_compute=true"
```

To shut down expensive components:

```bash
terraform apply -var="enable_compute=false"
```

This reduces monthly cost from ~$70 to ~$0–5 when idle. See ADR‑0008 for full details.

---

## 8. Running the Application Locally

From the `app/` directory:

```bash
uvicorn main:app --reload
```

This runs the FastAPI service on `http://localhost:8000`.

---

## 9. Destroying the Environment

To remove all infrastructure (except the state bucket and DynamoDB table):

```bash
terraform destroy
```

Use this only when you no longer need the environment.

---

## 10. Troubleshooting

- **ECS tasks not starting** Check CloudWatch Logs for task startup errors.

- **CI/CD deployment fails** Ensure the GitHub OIDC role trust policy matches your repository.

- **High AWS costs** Confirm the environment is toggled off when not in use.

---

## 11. Additional Documentation

All architectural decisions are documented in `docs/decisions/` using ADRs:

- Networking
- IAM
- Secrets
- Cost control
- Deployment strategy
- Logging and observability

Refer to ADR‑0001 through ADR‑0014 for full context.

---

This setup guide provides everything needed to bootstrap, deploy, and manage the environment in a
clean, reproducible way.
