# Agents

This document describes the agents (modules) in the Terraform AWS infrastructure setup.

## Network Agent

**Location:** `network/`

**Purpose:** The Network agent manages the Virtual Private Cloud (VPC) and all associated networking components to provide a secure and scalable network foundation for the infrastructure.

### Resources Created

- **VPC**: Main virtual network with DNS support enabled.
- **Internet Gateway**: Allows internet access for public subnets.
- **NAT Gateways**: Two NAT gateways (one per availability zone) for outbound internet access from private subnets.
- **Subnets**: Four subnets across two availability zones:
  - 2 Public subnets
  - 2 Private subnets
- **Route Tables**:
  - Public route table for internet access via IGW
  - Private route tables for NAT gateway access
- **Network ACL**: Simple ACL allowing all traffic (ingress and egress).
- **Security Groups**:
  - Bastion: Allows SSH (22) from anywhere, ICMP from VPC CIDR.
  - App: Allows SSH from bastion, HTTP/HTTPS from anywhere, ICMP from VPC CIDR.
  - DB: Allows SSH from bastion, PostgreSQL (5432) from anywhere, ICMP from VPC CIDR.
  - Cache: Allows SSH from bastion, Redis (6379-6380) from app SG and self, ICMP from VPC CIDR.
  - Queue: Allows SSH from bastion, RabbitMQ ports (4369, 5671-5672) from app SG and self, ICMP from VPC CIDR.

### Inputs

- `region`: AWS region
- `name`: Name for the VPC
- `cidr`: VPC CIDR block
- `tags`: Common tags
- `vpc_subnet_cidrs`: Map of subnet CIDRs

### Outputs

- `vpc_id`: VPC ID
- `private_subnets`: List of private subnet IDs
- `public_subnets`: List of public subnet IDs
- `security_groups`: Map of security group IDs by role

### Usage

1. Run `make config-us` to generate configuration files.
2. Edit `terraform.tfvars`, `backend.ini`, and `data.tf`.
3. Run `make init` to initialize Terraform.
4. Use `make plan`, `make apply`, `make destroy` for Terraform operations.

## Service Agent

**Location:** `service/`

**Purpose:** The Service agent deploys the application layer components including load balancing, auto-scaling compute resources, and bastion access.

### Resources Created

- **Application Load Balancer (ALB)**: Public-facing load balancer for HTTP traffic.
- **Target Group**: HTTP target group with health checks on port 80.
- **Launch Configuration**: EC2 `t2.medium` instances with Amazon Linux AMI, Docker, and Nginx setup.
- **Auto Scaling Group**: ASG with 1-3 instances, targeting private subnets, attached to the target group.
- **Bastion Instance**: t2.micro instance in public subnet for SSH access to private resources.

### User Data Script

The launch configuration uses `scripts/app.sh` which:

- Installs Docker and Docker Compose
- Pulls and runs Nginx container on port 80

### Inputs

- `region`: AWS region
- `key_name`: SSH key pair name
- `public_subnets`: List of public subnet IDs (from network agent)
- `private_subnets`: List of private subnet IDs (from network agent)
- `security_groups`: Map of security group IDs (from network agent)
- `vpc_id`: VPC ID (from network agent)
- `tags`: Common tags

### Outputs

- `lb_host`: ALB DNS name
- `bastion_host`: Bastion instance public DNS

### Usage

1. Run `make config-us` to generate configuration files.
2. Edit `terraform.tfvars`, `backend.ini`, and `data.tf`.
3. Run `make init` to initialize Terraform.
4. Use `make plan`, `make apply`, `make destroy` for Terraform operations.

Note: The service agent depends on outputs from the network agent via Terraform remote state.
