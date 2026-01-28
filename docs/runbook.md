# Runbook: aws-fastapi-devsecops

This runbook provides operational procedures for deploying, rolling back, and debugging the FastAPI service running on AWS ECS Fargate. It is designed for use during incidents, maintenance, and day‑to‑day operations.

---

## 1. Overview

**Service:** FastAPI application  
**Platform:** AWS ECS Fargate  
**Deployment:** GitHub Actions  
**Infrastructure:** Terraform  
**Networking:** ALB → ECS Service → Task  
**Container Registry:** Amazon ECR  
**Logging:** CloudWatch Logs  
**Monitoring:** CloudWatch Metrics, ALB Target Health, EventBridge Alerts  

Core components involved during incidents:

- ECS Cluster and Service
- Task Definition revisions
- ALB and Target Group health checks
- ECR image versions
- Terraform-managed infrastructure
- GitHub Actions workflows

---

## 2. Deployment Procedures

### 2.1 Standard Deployment (GitHub Actions)

1. Push to `main` triggers:
   - Linting and tests
   - Security scanning
   - Docker build
   - Push to ECR

2. Trigger the **ECS Deploy** workflow manually:
   - Select the desired image tag (default: latest)
   - Workflow updates the ECS task definition
   - ECS performs a rolling deployment

3. Verify deployment:
   - Check ECS service events
   - Confirm new tasks reach `RUNNING`
   - Confirm ALB target health is `healthy`
   - Hit `/health` endpoint

### 2.2 Manual Deployment (Fallback)

Use only if GitHub Actions is unavailable.

1. Build image locally:

```bash 
docker build -t <repo>:manual .
```

2. Authenticate and push:

```bash
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account>.dkr.ecr.<region>.amazonaws.com
docker push <repo>:manual
```

3. Update ECS task definition:
- Create new revision with updated image
- Update ECS service to use new revision
- Force new deployment

4. Validate health checks and logs.

---

## 3. Rollback Procedures

### 3.1 Rollback via GitHub Actions

1. Open the **Rollback ECS Task Definition** workflow.
2. Select the previous task definition revision.
3. Trigger workflow.
4. Validate:
- ECS service stabilises
- ALB target health returns to `healthy`
- Application responds on `/health`

### 3.2 Manual Rollback

1. Identify previous task definition revision:

```bash
aws ecs list-task-definitions --family-prefix <service>
```

2. Update service to use previous revision:

```bash
aws ecs update-service \
--cluster <cluster> \
--service <service> \
--task-definition <revision>
```

3. Force new deployment if needed:
```bash
aws ecs update-service --force-new-deployment ...
```

4. Validate logs and ALB health.

### 3.3 Rollback Terraform Changes

1. Revert the commit containing the breaking change.
2. Run:
```bash
terraform init
terraform plan
terraform apply
```
3. Validate affected resources.

---

## 4. Debugging & Incident Response

### 4.1 Application-Level Debugging

Check ECS task logs:
```bash
aws logs tail /aws/ecs/<service> --follow
```

Check ALB access logs (if enabled):
- S3 bucket: `alb-logs-<account>-<region>/AWSLogs/...`

Validate endpoints:
- `/health`
- `/process`

### 4.2 ECS Debugging

**Task stuck in PENDING**
- Subnet or security group misconfiguration
- Missing IAM permissions
- No available capacity

**Task running but unhealthy**
- App not listening on correct port
- Health check path incorrect
- Startup time too slow

**ALB returning 502/503**
- Target group health checks failing
- Container crash loop
- Wrong container port mapping

### 4.3 Terraform Debugging

**terraform apply fails**
- Missing IAM permissions
- Provider version mismatch
- Backend misconfiguration

**State drift**
- Manual AWS console changes
- Out-of-band resource updates

---

## 5. Observability & Monitoring

### 5.1 CloudWatch Logs
- ECS task logs: `/aws/ecs/<service>`
- ALB access logs (if enabled)

### 5.2 CloudWatch Metrics
- ECS CPU / Memory
- ALB 4xx / 5xx
- Target group health

### 5.3 Alerts
- EventBridge rules for ECS failures
- SNS notifications for critical events
- Billing alarms (Terraform-managed)

---

## 6. Access & Credentials

### 6.1 AWS Access
- Use AWS SSO login
- No long-lived IAM keys
- GitHub Actions uses OIDC role

### 6.2 Terraform Access
- Backend: S3 + DynamoDB
- Requires SSO session or OIDC (CI)

### 6.3 Local Development
- `.env` file for local FastAPI
- Docker for local builds

---

## 7. Contact & Escalation

**Service Owner:**  
James (Platform Engineer)

**Incident Logging:**  
`docs/incidents/` directory or external tracker

**Escalation Path:**  
- Review CloudWatch logs  
- Review ECS events  
- Review GitHub Actions logs  
- Roll back if needed  
- Document incident  

---

## 8. Appendix

### 8.1 Useful Commands

List ECS services:

```bash
aws ecs list-services --cluster <cluster>
```

Describe ECS service:

```bash
aws ecs describe-services --cluster <cluster> --services <service>
```

Tail logs:

```bash
aws logs tail /aws/ecs/<service> --follow
```

Force new deployment:

```bash
aws ecs update-service --cluster <cluster> --service <service> --force-new-deployment
```
---

### 8.2 Health Check Reference

Default ALB health check:
- Path: `/health`
- Port: `traffic-port`
- Interval: 30s
- Healthy threshold: 2
- Unhealthy threshold: 2

---

End of runbook.
