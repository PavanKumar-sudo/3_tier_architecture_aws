# 3-Tier Architecture Deployment on AWS using Terraform

This project automates the deployment of a **3-tier architecture** on AWS using **Terraform**. It sets up a complete infrastructure with Web, Application, and Database layers, ensuring a secure, scalable, and organized environment.


## 📚 Project Overview

The architecture includes:

- **Web Layer** (Public Subnet)
  - Application Load Balancer (ALB)
  - EC2 instances running Apache (HTTPD) Web Servers

- **Application Layer** (Private Subnet)
  - EC2 instances running Node.js backend application

- **Database Layer** (Private Subnet)
  - Amazon RDS (MySQL)

All components are provisioned with proper security group rules, subnet configurations, and routing.



## 🛠️ Project Setup

### 1. Prerequisites

- AWS Account
- Terraform installed (>= v1.0.0)
- AWS CLI configured with appropriate IAM permissions
- A valid SSH Key Pair in the specified AWS region



### 2. Configure `terraform.tfvars`

You must fill in the `terraform.tfvars` file with your environment-specific values:

```hcl
region                 = "us-east-1"
vpc_cidr               = "10.0.0.0/16"
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
db_username            = "admin"
db_password            = "yoursecurepassword"
key_name               = "your-keypair-name"
ami_id                 = "your-linux-ami-id"
instance_type          = "t2.micro"
```

**Important:**
- Use a Linux AMI (e.g., Amazon Linux 2).
- Confirm your Key Pair exists in the selected region.
- Secure your database password.



### 3. Initialize Terraform

```bash
terraform init
```
This command initializes the Terraform working directory and downloads all required providers.



### 4. Review the Execution Plan

```bash
terraform plan -var-file="terraform.vars"
```
This allows you to verify the changes Terraform will make.



### 5. Apply the Configuration

```bash
terraform apply -var-file="terraform.vars"
```
When prompted, type `yes` to proceed with resource creation.



## 🚀 What Happens During Deployment

- **VPC** with Public and Private Subnets.
- **Internet Gateway** and **NAT Gateway** setup.
- **Security Groups**:
  - Web servers allow HTTP (port 80) from the internet.
  - App servers allow traffic only from web servers.
  - RDS allows traffic only from app servers.
- **ALB** distributes traffic to web EC2 instances.
- **Web EC2 Instances** configured with Apache via User Data.
- **App EC2 Instances** configured with Node.js, PM2, and backend deployment via User Data.
- **RDS MySQL** single AZ database deployment.

## 📝 User Data Scripts Explained

### Web Layer User Data
- Install Apache HTTPD.
- Start and enable Apache service.

Example snippet:
```bash
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```

### App Layer User Data
- Install Node.js and PM2.
- Configure backend application.
- Create `.env` file with database connection variables.
- Start backend server using PM2.

Example snippet:
```bash
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
npm install pm2 -g
# Clone your app and run pm2 start
```
## 📤 Outputs

After applying the infrastructure, Terraform will output:

- `alb_dns_name`: Public DNS name of the Load Balancer.
- `db_endpoint`: Endpoint of the RDS MySQL database.

You can access your frontend application via:  
**http://<alb_dns_name>**

---

### 🎯 Terraform Apply Output

![Terraform Apply Output](https://github.com/user-attachments/assets/d98874f5-203f-48ad-95c9-a5f214cb6a62)

---

### 🎯 EC2 Instances Output

![EC2 Instances Output](https://github.com/user-attachments/assets/c173d9ff-5c98-4a1f-8d44-47c5880992b3)


### 🎯 Load Balancer Output

![Load Balancer Output](https://github.com/user-attachments/assets/77706e95-8c03-4b52-adbe-b337f89012b3)



### 🎯 Application Working Proof

When you add a note, it will be shown in the table:

![Note Added](https://github.com/user-attachments/assets/20bde7bd-562c-42c8-97c5-7c3a3ea05fbe)

![Database Save Confirmation](https://github.com/user-attachments/assets/c9f4ed07-381d-4789-ad67-03110a21d0d7)




## 💡 Best Practices & Tips

- **SSH Access:** Only web and app servers need SSH access via Bastion Host (if added).
- **Database Credentials:** Use secure secret management.
- **IAM Roles:** Assign minimum permissions necessary.
- **Auto Scaling:** Add later for production-grade deployments.
- **Logging:** Enable ALB access logs, EC2 system logs, and RDS logs.

## 🔄 Clean-up

To destroy the infrastructure when no longer needed:

```bash
terraform destroy --auto-approve
```


## 📊 Future Enhancements (Optional)

- Implement Auto Scaling Groups (ASG) App Layers.
- Configure HTTPS using ACM and ALB listeners.
- Add Route53 for custom domain.
- Create CI/CD pipelines for backend and frontend deployments.

