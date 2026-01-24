# Contributing Guide

Thank you for your interest in contributing to this AWS FastAPI DevSecOps reference project.  
This repository is designed to be clear, reproducible, and technically rigorous. The guidelines
below help maintain consistency and quality across code, infrastructure, and documentation.

---

## 1. Principles

Contributions should follow these principles:

- **Clarity over cleverness**  
  Code and infrastructure should be easy to understand and maintain.

- **Security by default**  
  No hard‑coded secrets, no long‑lived credentials, and least‑privilege IAM.

- **Reproducibility**  
  Everything should be deployable from scratch using Terraform and GitHub Actions.

- **Consistency**  
  Follow the existing patterns for structure, naming, and documentation.

---

## 2. Getting Started

Before contributing:

1. Read `README.md` for project context.
2. Follow `SETUP.md` to bootstrap your environment.
3. Review the ADRs in `docs/decisions/` to understand architectural decisions.

If something is unclear or missing, contributions to documentation are welcome.

---

## 3. Branching and Workflow

This project uses a simple Git workflow:

- Create a feature branch from `main`

  ```bash
  git checkout -b feature/my-change
  ```

- Commit changes with clear, descriptive messages
- Open a Pull Request into `main` when ready for review
- Ensure your PR includes:
  - a summary of the change
  - any relevant ADR updates
  - test results or validation steps

All changes must pass CI checks before merging.

---

## 4. Code Standards

### Application code (FastAPI)

- Follow PEP8 and standard Python formatting conventions
- Keep endpoints small and focused
- Avoid unnecessary dependencies
- Add type hints where practical

### Infrastructure (Terraform)

- Use the existing module structure and naming conventions
- Keep resources minimal and explicit
- Avoid embedding secrets in variables or state
- Run `terraform fmt` before committing

### CI/CD (GitHub Actions)

- Workflows should be:
  - minimal
  - deterministic
  - secure (OIDC only, no stored AWS keys)

---

## 5. Security Requirements

All contributions must adhere to the project’s security posture:

- No secrets in code, commits, or Terraform
- Use Parameter Store for sensitive values
- IAM policies must follow least‑privilege principles
- Container images must pass vulnerability scanning
- Infrastructure changes must not weaken isolation or access controls

If in doubt, reference ADR‑0011 (Secrets Management) and ADR‑0014 (IAM Model).

---

## 6. Testing and Validation

Before submitting a PR:

- Run the FastAPI app locally (optional)
- Validate Terraform changes

  ```bash
  terraform plan
  ```

- Ensure CI passes locally where applicable
- Confirm that the environment toggle still works if infrastructure was modified

---

## 7. Documentation Expectations

Changes that affect architecture, behaviour, or infrastructure should include:

- Updates to relevant ADRs
- Updates to `SETUP.md` if setup steps change
- Inline comments where clarity is needed

ADRs should follow the existing format and be placed in `docs/decisions/`.

---

## 8. Adding New ADRs

If your contribution introduces a new architectural decision:

1. Create a new ADR file under `docs/decisions/`
2. Use the next sequential ADR number
3. Follow the established structure (Context → Decision → Rationale → Consequences → Alternatives)
4. Reference the ADR in your PR description

---

## 9. Communication

If you’re unsure about an approach:

- Open a draft PR
- Add comments explaining your thinking
- Reference relevant ADRs or propose new ones

Clear communication helps maintain the project’s quality and intent.

---

## 10. Licensing

By contributing, you agree that your contributions will be licensed under the repository’s license.

---

Thank you for helping improve this project. Thoughtful contributions make this a stronger, more
useful reference for everyone.
