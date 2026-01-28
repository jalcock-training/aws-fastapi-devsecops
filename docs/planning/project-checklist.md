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
- [x] ADR (Architecture Decision Record) directory created
- [x] Project planning directory created

---

## 3. DevSecOps Pipeline Skeleton

### CI Pipeline (GitHub Actions)

- [x] CI workflow scaffolded
- [x] Linting stage (placeholder)
- [x] Unit test stage (placeholder)
- [x] Python dependency scanning (pip-audit)
- [x] SAST scanning (Bandit)
- [x] Container scanning (Trivy)
- [x] IaC scanning (Checkov)

### Build & Deploy Pipeline

- [x] Docker build workflow (placeholder image)
- [x] Push to ECR (placeholder)
- [x] Terraform plan/apply workflow scaffolded

---

## 4. Integrate App Into Pipeline

- [ ] CI pipeline updated to run real tests
- [ ] Security scanning runs on real code
- [ ] Docker image built from FastAPI app
- [x] Image pushed to ECR
- [ ] ECS service updated to use real image
- [ ] Deployment workflow finalised

---

## 5. Terraform Infrastructure Foundation

### 5.1 Core Terraform Setup

- [ ] Root module scaffolded
- [ ] Providers and versions pinned
- [ ] Remote state backend (S3 + DynamoDB)

### 5.2 Billing Alerts & Cost Controls

- [ ] CloudWatch billing alarm created (Terraform)
- [ ] SNS topic + email subscription for alerts
- [ ] Cost Explorer enabled (manual one‑time step)
- [ ] Cost Anomaly Detection monitor created (Terraform)
- [ ] Cost Anomaly Detection subscription created (Terraform)

### 5.3 Networking

- [ ] VPC created
- [ ] Public/private subnets
- [ ] NAT gateway (optional)
- [ ] Security groups defined

### 5.4 Compute & Deployment

- [ ] ECS cluster created
- [ ] Task execution role created
- [ ] Task role (least privilege)
- [ ] ALB configured
- [ ] ECS service scaffolded (placeholder container)

### 5.5 Observability & Security

- [ ] CloudTrail enabled
- [ ] S3 logging bucket created
- [ ] EventBridge alerts configured
- [ ] SNS notifications configured
- [ ] CloudWatch log groups created
- [ ] Metrics and dashboards added

---

## 6. FastAPI Application (Onboard Into Existing Platform)

- [ ] Project scaffold created (`app/`)
- [ ] Basic FastAPI service implemented
- [ ] `/health` endpoint added
- [ ] `/process` endpoint added
- [ ] Logging configured
- [ ] Unit tests added
- [ ] Requirements file created
- [ ] Dockerfile created and tested locally

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

- [ ] Add staging environment
- [ ] Add WAF in front of ALB
- [ ] Add Secrets Manager integration
- [ ] Add automated dependency updates (Dependabot)
- [ ] Add load testing
- [ ] Add performance dashboards

---
