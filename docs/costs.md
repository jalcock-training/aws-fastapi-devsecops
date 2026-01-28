# Cost Breakdown (ECS, ALB, NAT Gateway, CloudWatch Logs)

This document provides a practical cost breakdown for the aws-fastapi-devsecops architecture. It focuses on the major cost‑bearing components: ECS Fargate, Application Load Balancer (ALB), NAT Gateway, and CloudWatch Logs.

The values below are based on AWS public pricing. Actual costs vary by region and usage patterns.

---

## 1. ECS Fargate

ECS Fargate charges for vCPU-hours and GB-hours. You pay only for the resources allocated to your running tasks.

**What you pay for**

1. vCPU per hour  
1. Memory (GB) per hour  
1. Optional: additional ephemeral storage beyond the free baseline  

**Example configuration**

- 0.25 vCPU  
- 0.5 GB RAM  
- 1 task running 24/7  

**Cost drivers**

1. Number of running tasks  
1. Task size (vCPU + memory)  
1. Runtime hours  

---

## 2. Application Load Balancer (ALB)

ALB pricing has two components: hourly cost and Load Balancer Capacity Units (LCUs).

**What you pay for**

1. ALB hourly charge  
1. LCU-hours (based on new connections, active connections, processed bytes, and rule evaluations)  

**Typical usage for a small service**

- 1 ALB running continuously  
- 1–2 LCUs depending on traffic volume  

**Cost drivers**

1. ALB uptime (always on)  
1. Traffic volume  
1. Number of rules and evaluations  

---

## 3. NAT Gateway

NAT Gateways are often the most expensive part of small AWS architectures.

**What you pay for**

1. NAT Gateway hourly charge  
1. Data processed (per GB)  

**Why NAT costs can spike**

1. ECS tasks pulling container images  
1. Outbound API calls  
1. CloudWatch Logs traffic  
1. Any service in private subnets accessing the public internet  

**Cost optimisation options**

1. Use VPC endpoints for S3, ECR, CloudWatch Logs  
1. Minimise outbound traffic  
1. Avoid unnecessary image pulls  

---

## 4. CloudWatch Logs

CloudWatch Logs charges for ingestion, storage, and Insights queries.

**What you pay for**

1. Log ingestion (per GB)  
1. Log storage (per GB-month)  
1. Log Insights queries (per GB scanned)  

**Typical ECS log volume**

- 50–200 MB/day depending on log level  
- Higher if debug logging is enabled  

**Cost optimisation options**

1. Reduce log verbosity  
1. Set retention to 7–30 days  
1. Avoid enabling Container Insights unless required  

---

## 5. Summary Table

| Component            | What You Pay For                          | Notes                                      |
|----------------------|---------------------------------------------|--------------------------------------------|
| ECS Fargate          | vCPU-hours, GB-hours                        | Scales with task count and size            |
| Application LB       | Hourly cost + LCU-hours                     | Always on; LCUs depend on traffic          |
| NAT Gateway          | Hourly cost + data processed                | Often the largest cost for small workloads |
| CloudWatch Logs      | Ingestion, storage, Insights queries        | Ingestion is the main cost driver          |

---

## 6. Practical Notes for This Architecture

**ECS**

1. FastAPI service is lightweight → low compute cost  
1. Scaling horizontally increases cost linearly  

**ALB**

1. Always-on cost even with zero traffic  
1. LCUs stay low unless throughput is high  

**NAT Gateway**

1. Required for private subnets  
1. Can dominate monthly cost if not optimised  

**CloudWatch Logs**

1. Costs grow with verbosity  
1. Retention settings matter  

---
