# Alerting Pipeline Architecture

The alerting pipeline provides visibility into operational issues, security events, and cost
anomalies across the AWS environment.  
It is designed to be simple, reliable, and fully automated.

---

## Objectives

- Detect abnormal spend early
- Surface operational failures quickly
- Provide audit visibility for platform activity
- Route alerts to a central notification channel (SNS)

---

## Components

### 1. CloudWatch Billing Alarm

Monitors the `EstimatedCharges` metric in `us-east-1`.

Triggers when spend exceeds a defined threshold (e.g., $5).

### 2. Cost Anomaly Detection

Uses AWS Cost Explorer to detect unusual spending patterns.

Includes:

- Anomaly monitor
- Anomaly subscription
- SNS notifications

### 3. SNS Topic

Central notification hub for:

- Billing alarms
- Cost anomalies
- Future operational alerts

Email subscription is confirmed manually.

### 4. EventBridge (Future Enhancement)

Will route:

- ECS task failures
- Deployment issues
- Security findings

To the same SNS topic or additional channels.

---

## Alert Flow

`AWS Service → Event/Metric → Alarm/Monitor → SNS Topic → Email Notification`

Examples:

- Unexpected spend → Billing Alarm → SNS → Email
- Sudden cost spike → Anomaly Detection → SNS → Email
- ECS task crash (future) → EventBridge → SNS → Email

---

## Principles

- Alerts must fire before significant impact occurs
- All alerting infrastructure is defined in Terraform
- Notifications are routed to a single, centralised channel
- Cost controls are treated as part of the security baseline

---

This alerting pipeline ensures the platform remains visible, predictable, and safe as workloads
evolve.
