### **README.md for Terraform and Ansible Project**

---

# **Infrastructure as Code (IaC) with Terraform and Ansible**

This project automates the provisioning of AWS infrastructure using **Terraform** and configuration management using **Ansible**. The infrastructure includes a VPC with multiple subnets, EC2 instances, a Bastion Host, an Application Load Balancer (ALB), IAM roles, and a Dockerized Nginx setup. Additionally, it ensures that Docker logs are sent to **CloudWatch** for monitoring.

---

## **Table of Contents**

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [Terraform](#terraform-setup)
  - [Ansible](#ansible-setup)
- [Project Structure](#project-structure)
- [Detailed Explanation](#detailed-explanation)
  - [Terraform Configuration](#terraform-configuration)
  - [Ansible Configuration](#ansible-configuration)
- [Source of Information](#source-of-information)

---

## **Overview**

This project provisions a **VPC** with private and public subnets, **EC2 instances**, and an **ALB**. The **EC2 instances** will run **Nginx in Docker containers**, each with a customized `index.html`. Logs from these containers will be forwarded to **CloudWatch** for monitoring purposes. An **Ansible playbook** will be used to configure the EC2 instances, install Docker, deploy the Nginx containers, and configure CloudWatch.

---

## **Prerequisites**

Before you start, make sure you have the following tools installed:

- **Terraform** (v1.0 or above) for provisioning AWS infrastructure
- **Ansible** (v2.9 or above) for configuring host services
- **AWS CLI** (optional, for accessing AWS resources)
- **Docker** (optional, for testing locally)
- **Git** for version control
- **Python 3** (required by Ansible)

You should also have an **AWS account** with appropriate access (IAM role with permissions to create EC2 instances, VPCs, IAM roles, etc.).

---

## **Setup Instructions**

### **Terraform Setup**

1. **Clone the Repository:**

   Clone the repository to your local machine:

   ```bash
   git clone <repository_url>
   cd <repository_name>
   ```

2. **Configure Terraform Provider:**

   Make sure your AWS credentials are set up either in `~/.aws/credentials` or through environment variables:

   ```bash
   export AWS_ACCESS_KEY_ID=<your_access_key>
   export AWS_SECRET_ACCESS_KEY=<your_secret_key>
   export AWS_DEFAULT_REGION=us-west-2
   ```

3. **Terraform Initialization:**

   Initialize Terraform in the root of the project:

   ```bash
   terraform init
   ```

4. **Terraform Apply:**

   Apply the Terraform configuration to provision the infrastructure:

   ```bash
   terraform apply
   ```

   You’ll be prompted to confirm before applying. Type `yes` to proceed. This will provision the VPC, EC2 instances, ALB, IAM roles, and CloudWatch configurations.

### **Ansible Setup**

1. **Install Ansible:**

   If you haven't installed Ansible yet, you can do so with the following commands:

   ```bash
   sudo apt update
   sudo apt install ansible
   ```

   Or, for macOS:

   ```bash
   brew install ansible
   ```

2. **Configure SSH Access:**

   Make sure your **private SSH key** (created by Terraform) is correctly set in your `ansible.cfg`:

   ```ini
   [defaults]
   private_key_file = ~/.ssh/my_terraform_key.pem
   ```

3. **Run the Ansible Playbook:**

   To deploy and configure the EC2 instances with Docker and Nginx, use the following command:

   ```bash
   ansible-playbook -i inventory.ini playbook.yml
   ```

   This will install CloudWatch Agent, Docker, and configure Nginx on all EC2 instances as defined in the `nginx` role.

---

## **Project Structure**

```plaintext
project/
│
├── terraform/
│   ├── main.tf                 # Terraform configuration file
│   ├── modules/                # Terraform modules
│   ├── outputs.tf              # Terraform outputs
│   ├── variables.tf            # Terraform variables
│   └── terraform.tfvars        # Terraform variable values (optional)
│
├── ansible/
│   ├── inventory.ini           # Ansible inventory for EC2 instances
│   ├── ansible.cfg             # Ansible configuration
│   ├── playbook.yml            # Main Ansible playbook
│   ├── roles/
│   │   ├── cloudwatch/         # Role to install CloudWatch agent
│   │   ├── docker/             # Role to install and configure Docker
│   │   └── nginx/              # Role to install and configure Nginx
│   └── vars/
│       └── main.yml            # Variables file
│
├── terraform_output.json       # Terraform output JSON file
└── README.md                   # Project README
```

---

## **Detailed Explanation**

### **Terraform Configuration**

1. **VPC Configuration**:
   The VPC is created with a CIDR block of `10.161.0.0/24`, which is subdivided into **public** and **private subnets**. 
   
   The **public subnets** are used for the Bastion Host (jump server) and the ALB. The **private subnets** are used for the EC2 instances running Nginx.

2. **EC2 Instances**:
   - **Bastion Host**: This EC2 instance is used to access the private instances. It has public access and is exposed via an **Elastic IP**.
   - **Private EC2 Instances**: These instances run Nginx inside Docker containers, and they are not directly accessible from the public internet.

3. **ALB**:
   The **Application Load Balancer (ALB)** is configured to serve HTTP traffic (port 80) to the private EC2 instances. The ALB checks the health of each instance through health checks.

4. **IAM Roles**:
   IAM roles are created to allow EC2 instances to push logs to **CloudWatch**. These roles are attached to the EC2 instances during their creation.

5. **CloudWatch Agent**:
   The **CloudWatch agent** is installed and configured to collect Docker logs from the EC2 instances and send them to CloudWatch for centralized monitoring.

### **Ansible Configuration**

1. **CloudWatch Agent**:
   The **CloudWatch Agent** is installed on all EC2 instances to collect Docker logs. A JSON configuration file is created dynamically using Ansible's **Jinja2 templating**.

2. **Docker Configuration**:
   - **Docker** is installed on the EC2 instances.
   - The `ec2-user` is added to the **docker group** to allow the user to manage Docker without requiring `sudo`.
   - **Docker permissions** are fixed to ensure the user can interact with the Docker socket (`/var/run/docker.sock`).

3. **Nginx Setup**:
   - The **Nginx Docker container** is configured to run with a custom `index.html` that displays a message with the host’s name.
   - Each EC2 instance running Nginx will have a unique `index.html`, displaying "Hello from [hostname]" using **Jinja2 templating**.

---

## **Source of Information**

The following resources were used to develop and guide the implementation of this project:

- **Terraform Documentation**:
  - [AWS EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
  - [Terraform VPC Configuration](https://www.terraform.io/docs/providers/aws/r/vpc.html)
- **CloudWatch Installation**:
  - [Simplifying Monitoring using Ansible to Install CloudWatch Agent](https://signiance.com/simplifying-monitoring-using-ansible-to-install-cloudwatch-agent/)
- **YouTube Videos**:
  - [Terraform Setup Guide](https://youtu.be/VVScigeGg2k?si=cFzqDuk77PwP-C2K)
  - [Ansible Playbook Tutorial](https://youtu.be/r-26_oUKDA4?si=JAtZmCevyJbZVM83)
  
These resources helped in defining best practices for Terraform infrastructure management and efficient Ansible playbook execution.

---

### **How to Contribute**

If you want to contribute to this project, please fork the repository, create a new branch, and submit a pull request with your changes.

---

Let me know if you'd like to add any additional sections or need further explanations on any part!