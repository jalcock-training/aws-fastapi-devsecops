# AWS FastAPI DevSecOps

A complete, end‑to‑end AWS DevSecOps reference implementation built around a small FastAPI microservice, a secure AWS foundation, and a fully automated CI/CD pipeline. This project demonstrates how to design, deploy, and operate a modern cloud application using Terraform, ECS Fargate, GitHub Actions, and DevSecOps best practices.

The architecture is intentionally minimal, reproducible, and technically rigorous — suitable for learning, portfolio demonstration, and future expansion.

---

## What this project showcases

- A production‑style FastAPI microservice packaged as a container  
- A fully automated CI/CD pipeline using GitHub Actions with OIDC  
- Security scanning across SAST, SCA, container scanning, and IaC scanning  
- A secure AWS foundation built with Terraform and least‑privilege IAM  
- Deployment to ECS Fargate behind an Application Load Balancer  
- Centralised logging and observability using CloudWatch  
- A cost‑controlled environment with an on/off toggle mode  
- A clean, well‑documented architecture using ADRs  

---

## Why this exists

This project serves as a practical demonstration of:

- Secure cloud architecture patterns  
- Infrastructure as Code discipline  
- DevSecOps automation and continuous delivery  
- AWS platform engineering fundamentals  
- Stateless service design and reproducible environments  
- Cost‑efficient cloud development workflows  

It is designed to be small, clear, and realistic — a reference you can build on or use to demonstrate engineering capability.

---

## Repository structure

- `app/` — FastAPI application code  
- `infra/` — Terraform configuration for AWS infrastructure  
- `ci/` — GitHub Actions workflows  
- `docs/decisions/` — Architecture Decision Records (ADRs)  
- `SETUP.md` — Environment setup and bootstrap guide  

See ADR‑0001 for a full breakdown.

---

## Key features

### Security by default
- OIDC‑based CI/CD authentication (no long‑lived AWS keys)  
- Least‑privilege IAM roles for deployment and runtime  
- Automated scanning for code, dependencies, containers, and IaC  

### Automated deployments
- GitHub Actions builds and pushes images to ECR  
- ECS rolling deployments with health‑checked updates  
- No manual steps once the environment is bootstrapped  

### Modular, reproducible infrastructure
- VPC, subnets, routing, IAM, ECS, ALB, and logging defined in Terraform  
- Clear separation of concerns across modules  
- Stateless service design for easy scaling and redeployment  

### Cost‑controlled environment
- NAT Gateway and ALB can be toggled off when not in use  
- Idle cost reduced from approximately $70/month to $0–5/month  
- Documented in ADR‑0008  

---

## Status

Active development phase.  
Core infrastructure, documentation, and the initial FastAPI service are in place. CI/CD, security scanning, and deployment workflows are being refined as the project evolves.

---

## Documentation

All architectural decisions are captured as ADRs in `docs/decisions/`.  
Start with:

- ADR‑0001 — Repository Structure  
- ADR‑0004 — Infrastructure Platform  
- ADR‑0008 — Cost Controls Strategy  
- ADR‑0014 — IAM & Access Control Model  

For setup instructions, see `SETUP.md`.

---

## Roadmap

- Add optional persistence layer (ADR‑0012)  
- Expand observability with dashboards and alarms  
- Introduce additional microservices or API routes  
- Add performance testing and load‑test automation  
- Explore CloudFront and WAF integration  

---

This repository is a living reference — simple enough to understand quickly, but deep enough to demonstrate real‑world DevSecOps and AWS platform engineering practices.
