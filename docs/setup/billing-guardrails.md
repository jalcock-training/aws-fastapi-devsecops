# Billing Guardrails

Cost controls are established early to prevent unexpected charges and to provide visibility into
spend.

## Pending Tasks

- Configure CloudWatch billing alarm via Terraform
- Create SNS topic for billing notifications
- Enable Cost Explorer (manual one‑time step)
- Configure Cost Anomaly Detection via Terraform

## Principles

- Cost visibility is part of the security baseline
- Alerts must fire before significant spend occurs
- All cost controls are codified in Terraform where possible
