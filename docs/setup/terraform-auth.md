# Terraform Authentication

Terraform authenticates to AWS using IAM Identity Center (SSO). This avoids long‑lived credentials
and ensures all access is traceable.

## Workflow

1. Log in via SSO: `aws sso login`

2. Export the SSO profile for Terraform: `export AWS_PROFILE=default`

3. Run Terraform commands normally: `terraform init` `terraform plan` `terraform apply`

## Notes

- No IAM users or access keys are created for Terraform
- Authentication is short‑lived and must be refreshed periodically
- This approach aligns with AWS best practices for modern environments
