# Project Checklist (Platform‑First DevSecOps Build)

---

## 1. Account & Access Setup

- [x] Root account secured (MFA, no access keys, alternate contacts)
- [x] IAM Identity Center enabled
- [x] First admin user created
- [x] AdministratorAccess permission set assigned
- [x] SSO login verified

---

## 2. Repository & Documentation

- [x] GitHub repository created (`aws-fastapi-devsecops`)
- [x] Initial README added
- [x] Documentation structure created (`docs/`)
- [x] Setup documentation drafted
- [x] Architecture section scaffolded
- [x] ADR directory created
- [x] Project planning directory created
- [x] Runbook created (deploy, rollback, debug)
- [x] Cost breakdown documented (ECS, ALB, NAT, logs)

---

## 3. DevSecOps Pipeline Skeleton

### 3.1 CI Pipeline (GitHub Actions)

- [x] CI workflow scaffolded
- [x] Linting (Ruff, Black, markdownlint)
- [x] Unit test stage (placeholder)
- [x] Python dependency scanning (pip-audit)
- [x] SAST scanning (Bandit)
- [x] Container scanning (Trivy)
- [x] IaC scanning (Checkov)
- [x] CI caching added (pip + Docker layers)
- [x] Pre-commit hooks configured
- [x] Branch protection rules defined
- [x] Local Git hooks added (pre-commit, pre-push) for linting, formatting, and safety checks

### 3.2 Build & Deploy Pipeline

- [x] Docker image built from FastAPI app
- [x] Push to ECR (real image)
- [x] Terraform plan/apply workflow scaffolded
- [x] Deployment workflow scaffolded (ECS)

---

## 4. Integrate App Into Pipeline

- [ ] FastAPI project scaffold created (`app/`)
- [ ] Basic FastAPI service implemented
- [ ] `/health` endpoint added
- [ ] `/process` endpoint added
- [ ] Logging configured
- [ ] Unit tests added
- [ ] Requirements file created
- [ ] Dockerfile created and tested locally
- [ ] Local dev environment documented
- [ ] API contract documented (OpenAPI)

---

## 5. Terraform Infrastructure Foundation

### 5.1 Core Terraform Setup

- [ ] Terraform folder structure defined (`modules/`, `envs/`, `global/`)
- [ ] Root module scaffolded
- [ ] Providers and versions pinned
- [ ] Remote state backend (S3 + DynamoDB)
- [ ] Makefile or task runner for Terraform commands

### 5.2 Billing Alerts & Cost Controls

- [ ] CloudWatch billing alarm (Terraform)
- [ ] SNS topic + email subscription
- [ ] Cost Explorer enabled (manual)
- [ ] Cost Anomaly Detection monitor (Terraform)
- [ ] Cost Anomaly Detection subscription (Terraform)

### 5.3 Networking

- [ ] VPC created
- [ ] Public/private subnets
- [ ] NAT gateway (optional)
- [ ] Security groups defined

### 5.4 Compute & Deployment

- [ ] ECS cluster created
- [ ] Task execution role created
- [ ] Task role (least privilege)
- [ ] ECR lifecycle policy added
- [ ] ECS task definition templated
- [ ] ALB configured
- [ ] ECS service scaffolded (placeholder container)
- [ ] Deployment circuit breakers enabled

### 5.5 Observability & Security

- [ ] CloudTrail enabled
- [ ] S3 logging bucket created
- [ ] ALB access logs enabled
- [ ] EventBridge alerts configured
- [ ] SNS notifications configured
- [ ] CloudWatch log groups created
- [ ] ECS task logs shipped to CloudWatch
- [ ] Basic CPU/memory alarms for ECS service
- [ ] Metrics and dashboards added

---

## 6. Deployment Integration

- [ ] ECS service updated to use real image
- [ ] Deployment workflow finalised
- [ ] Blue/green or rolling deployment strategy defined
- [ ] Post-deployment smoke tests added

---

## 7. Finalisation & Polish

- [ ] Architecture diagrams added
- [ ] Documentation completed
- [ ] ADRs finalised
- [ ] Cost controls reviewed
- [ ] README updated with final details
- [ ] Project tagged with a release version

---

## 8. Stretch Goals (Optional)

- [ ] Staging environment added
- [ ] WAF in front of ALB
- [ ] Secrets Manager integration
- [ ] Automated dependency updates (Dependabot)
- [ ] Load testing added
- [ ] Performance dashboards added
