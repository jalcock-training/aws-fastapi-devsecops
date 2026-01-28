# ADR‑0003: Terraform Project Structure

## Status

Accepted

## Date

2026‑01‑23

## Context

This project requires a Terraform structure that supports:

- clear separation of concerns
- reproducibility across environments
- safe, isolated state files
- compatibility with CI/CD automation
- readability for reviewers
- future expansion to multiple environments

Terraform supports several organisational patterns, ranging from monolithic roots to
Terragrunt‑based multi‑account structures. For this project, the structure must remain simple while
still reflecting industry standard platform engineering practices.

---

## Decision

**The project will use a single root module with a `modules/` directory for reusable components and
an `environments/` directory for environment‑specific configuration.**

The structure is:

terraform/ ├── modules/ │ ├── network/ │ ├── ecs-service/ │ ├── iam/ │ └── logging/ ├──
environments/ │ └── dev/ │ ├── main.tf │ ├── variables.tf │ └── outputs.tf ├── providers.tf ├──
versions.tf ├── variables.tf └── outputs.tf

---

## Why We Start With Only a `dev` Environment

This project follows a **platform‑first** approach. Before introducing multiple environments, the
following must be stable:

- Terraform backend
- Modules
- ECS service
- Networking
- Alerting
- CI/CD pipeline
- Cost controls

A single environment (`dev`) provides a safe place to:

- iterate quickly
- test modules
- validate assumptions
- refine CI/CD
- avoid unnecessary AWS cost

Once the platform is stable, adding `prod` is trivial:

terraform/environments/ ├── dev/ └── prod/

---

## How Terraform Is Executed

### Terraform is **always** run from inside an environment directory

Example:

`cd terraform/environments/dev` `terraform init` `terraform plan` `terraform apply`

Each environment directory:

- defines its own variables
- has its own state file
- imports the root module
- is the entry point for CI/CD

This ensures **state isolation** and **environment independence**.

---

## Why Terraform Is _Not_ Run From the Root Directory

The root directory is **not** an executable Terraform project. It acts as a **module** that
environment directories call.

Running Terraform from the root would:

- mix environment state
- break isolation
- confuse CI/CD
- violate best practices

The root directory contains shared configuration (providers, versions, variables), but **execution
happens only inside environment directories**.

---

## CI/CD Integration

GitHub Actions will:

- target a specific environment directory
- run `terraform init/plan/apply` from that directory
- use the remote backend defined for that environment

This keeps deployments predictable and safe.

---

## Rationale

### Separation of Concerns

- `modules/` contains reusable building blocks
- `environments/` contains environment‑specific configuration
- root module orchestrates shared providers and global settings

### Scalability

- Adding `prod` or `staging` requires no structural changes
- Modules evolve independently
- Supports future multi‑account expansion

### Clarity

- Reviewers can understand the layout immediately
- Mirrors common patterns used in production Terraform repositories

### Simplicity

- No Terragrunt or complex orchestration
- Easy to navigate and reason about
- Ideal for a portfolio‑scale project

---

## Consequences

### Benefits — ADR‑0003

- Clean, maintainable structure
- Predictable CI/CD workflows
- Safe state isolation
- Easy onboarding for new contributors

### Trade‑offs — ADR‑0003

- Slightly more boilerplate than a monolithic root
- Requires discipline to keep modules focused

---

## Alternatives Considered

### Monolithic Root Module

Rejected due to poor scalability and maintainability.

### Multiple Root Modules (one per environment)

Rejected due to duplication and inconsistent configuration.

### Terragrunt

Rejected as unnecessary complexity for a single‑account project.

---

This structure provides a clean, scalable, and professional Terraform foundation that aligns with
the project’s platform‑first DevSecOps approach.
