# AWS Account Bootstrap Guide

This document describes the one‑time AWS account preparation required before deploying the FastAPI
DevSecOps environment. These steps create the Terraform backend, IAM prerequisites, and baseline
security controls that the rest of the infrastructure depends on.

These actions are performed once per AWS account.

---

## 1. Prerequisites

Before bootstrapping the account, ensure you have:

- An AWS account with administrative access
- AWS CLI v2 installed and configured
- Terraform installed locally
- A region selected (this project assumes `ap-southeast-1`)

---

## 2. Create Terraform State Backend

Terraform requires a remote backend for storing state and managing locks. Create the following
resources manually:

### 2.1 S3 bucket for Terraform state

Choose a globally unique bucket name, for example:

```bash
aws s3api create-bucket \
  --bucket <your-terraform-state-bucket> \
  --region ap-southeast-1 \
  --create-bucket-configuration LocationConstraint=ap-southeast-1
```

Enable versioning:

```bash
aws s3api put-bucket-versioning \
  --bucket <your-terraform-state-bucket> \
  --versioning-configuration Status=Enabled
```

### 2.2 DynamoDB table for state locking

```bash
aws dynamodb create-table \
  --table-name <your-terraform-lock-table> \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

Update `infra/backend.tf` with your bucket and table names.

---

## 3. Create IAM Role for GitHub Actions (OIDC)

This project uses GitHub Actions with OIDC for secure, short‑lived AWS credentials.

### 3.1 Create the OIDC identity provider

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

### 3.2 Create the GitHub deployment role

This role allows GitHub Actions to:

- Push images to ECR
- Register new ECS task definitions
- Trigger deployments

Attach a trust policy that restricts access to your repository only.

You will update the trust policy later with your repo details.

---

## 4. Create KMS Key (Optional)

If you want to encrypt:

- Parameter Store SecureString values
- S3 buckets
- Logs

You may create a dedicated KMS key:

```bash
aws kms create-key --description "DevSecOps project key"
```

Record the Key ID for use in Terraform.

---

## 5. Configure AWS Budgets (Optional but recommended)

Set a monthly budget to avoid unexpected charges:

```bash
aws budgets create-budget \
  --account-id <your-account-id> \
  --budget file://budget.json
```

Where `budget.json` defines your monthly threshold.

This aligns with ADR‑0008 (Cost Controls Strategy).

---

## 6. Validate Your AWS CLI Access

Run:

```bash
aws sts get-caller-identity
```

You should see your account ID and IAM identity.  
If not, fix your credentials before continuing.

---

## 7. Next Steps

Once the bootstrap steps are complete:

1. Navigate to the `infra/` directory
2. Run `terraform init`
3. Apply the infrastructure using `terraform apply`
4. Follow `SETUP.md` for application deployment and environment toggling

---

This bootstrap guide ensures the AWS account is correctly prepared for Terraform, CI/CD, and secure
operation of the FastAPI DevSecOps environment.
