# terraform-aws-eks

**Terraform configuration to provision a VPC and Amazon EKS cluster on AWS**

This repository automates creation of a secure, production-grade AWS infrastructure with:

* A custom **Virtual Private Cloud (VPC)** with public/private subnets, NAT gateways, route table configuration, and optional VPC Endpoints
* A fully managed **Amazon Elastic Kubernetes Service (EKS)** control plane tied into the VPC
* Worker nodes (self‌-managed or managed node groups) joining the EKS cluster
* IAM roles and policies for cluster control plane, node groups, and optional addons (e.g. autoscaler, ALB controller)

---

## 🔧 Prerequisites

* Terraform v1.3 +
* AWS CLI configured (`aws configure`)
* IAM user with sufficient rights to manage VPC, EKS, IAM, EC2, autoscaling, and Route53 (if using private domain integration)
* kubectl (optional, to interact with created cluster)

---

## 📦 Repository Structure

```
├── main.tf                 # Root level resources (provider, backend, locals)
├── vpc.tf                  # VPC, subnets, NATs, and routing resources
├── eks.tf                  # EKS cluster resource and control-plane IAM
├── node_groups.tf          # Worker nodes (managed or self-managed)
├── outputs.tf              # Exposed values: cluster endpoint, kubeconfig, subnets, etc.
├── variables.tf            # Input variable definitions with defaults
├── versions.tf             # Terraform and provider version constraints
└── examples/               # Sample usage variations
```

---

## 🚀 Usage

1. **Clone the repository**

   ```bash
   git clone https://github.com/Periyasamy10/terrafrom-aws-eks.git
   cd terrafrom-aws-eks
   ```

2. **Initialize Terraform and providers**

   ```bash
   terraform init
   ```

3. **Customize variables**
   You can override defaults via:

   * `terraform.tfvars`
   * `-var "key=value"` on the CLI
   * Environment variables (e.g. `TF_VAR_cluster_name`, `TF_VAR_node_count`)

4. **Plan and apply**

   ```bash
   terraform plan
   terraform apply
   ```

   Confirm with `yes`. Terraform will provision:

   * VPC with appropriate subnets/security
   * EKS control plane in the VPC
   * Worker nodes joining the cluster
   * IAM roles, policies, and autoscaling as configured

5. **Retrieve kubeconfig**

   After creation, output will include a `kubeconfig` snippet you can export:

   ```bash
   export KUBECONFIG=$(terraform output kubeconfig_path)
   kubectl get nodes
   ```

---

## 🔧 Key Configuration Options

| Variable                              | Description                                     | Default                  |
| ------------------------------------- | ----------------------------------------------- | ------------------------ |
| `cluster_name`                        | EKS cluster name                                | `"my-eks"`               |
| `aws_region`                          | AWS region for deployment                       | `"ap-south-1"`           |
| `vpc_cidr_block`                      | CIDR for VPC                                    | `"10.0.0.0/16"`          |
| `public_subnet_cidrs`                 | List of CIDRs for public subnets                | `["10.0.1.0/24", ...]`   |
| `private_subnet_cidrs`                | List of CIDRs for private subnets               | `["10.0.101.0/24", ...]` |
| `node_group_strategy`                 | `"managed"` or `"self-managed"` node group type | `"managed"`              |
| `node_count_min/max`                  | Auto-scaling group min/max sizes                | `1` / `3`                |
| Addons (e.g. `enable_alb_controller`) | Toggle helm-chart deployments                   | `false`                  |

You can include modules like VPC endpoints, cluster‌-autoscaler, ALB Controller, and others.

---

## 🧪 Example

Here’s a minimal example in `examples/simple`:

```hcl
module "eks" {
  source            = "../"
  cluster_name      = "dev-cluster"
  aws_region        = "ap-south-1"
  node_group_strategy = "managed"
  node_count_min    = 2
  node_count_max    = 4
  public_subnet_cidrs  = ["10.0.0.0/24","10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.100.0/24","10.0.101.0/24"]
}
```

---

## ✅ Clean Up

When you're done:

```bash
terraform destroy
```

This will tear down all created AWS resources and reduce charges.

---

## ⚖️ Best Practices & Recommendations

* ✅ Use **Terraform Cloud or remote state backend** (e.g. S3 + DynamoDB) for team collaboration
* ✅ Use Terraform **workspaces** (`dev`, `staging`, `prod`) with separate variable sets
* ✅ Enable **Infrastructure logging & monitoring** (CloudWatch, Prometheus via Helm)
* ✅ Add **cluster-autoscaler** with proper IAM and Helm provider for dynamic node scale up/down
* ✅ Use **private endpoint access** if needing VPC -isolated control plane access

---

## 📋 References

* Terraform AWS EKS module documentation ([terraform-aws-modules/terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks))
* Example tutorials:

  * “Building a custom VPC and EKS cluster with Terraform” ([medium.com](https://medium.com/@alex.veprik/setting-up-aws-eks-cluster-entirely-with-terraform-e90f50ab7387))
  * AWS EKS Terraform blueprints ([github.com](https://github.com/aws-ia/terraform-aws-eks-blueprints))

---

## 📍 Summary

This Terraform repo creates a reusable, configurable AWS infrastructure for:

* Custom VPC networking
* Secure and scalable Amazon EKS clusters
* Worker node groups
* IAM policy enforcement and optional addons

