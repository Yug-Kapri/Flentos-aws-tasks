# Flentos-aws-tasks

A set of practical AWS infrastructure tasks and configurations — useful for learning and demonstrating AWS fundamentals (VPC, EC2, Load Balancer, Auto-Scaling, architecture diagrams, etc.)

---

## Table of Contents

- [Project Overview](#project-overview)  
- [Task 1: Networking & Subnetting (AWS VPC Setup)](#task-1-networking--subnetting-aws-vpc-setup)  
- [Task 2: EC2 Static Website Hosting](#task-2-ec2-static-website-hosting)  
- [Task 5: AWS Architecture Diagram (draw.io / design)](#task-5-aws-architecture-diagram-drawio-design)  
- [How to Use / Run / Deploy](#how-to-use---run---deploy)  
- [Cleanup & Cost Advice](#cleanup---cost-advice)  

---

## Project Overview

This repository contains multiple AWS practice tasks designed to help you get hands-on experience with AWS core services and architecture patterns.  
Each task includes infrastructure setup (via Terraform / CloudFormation / manual steps), and — wherever applicable — screenshots or diagrams to illustrate the configuration and results.

---

## Task 1: Networking & Subnetting (AWS VPC Setup)

**Requirements**

- Create a VPC  
- Create 2 Public Subnets  
- Create 2 Private Subnets  
- Attach an Internet Gateway (IGW)  
- Configure a NAT Gateway for outbound internet access from private subnets

---

## Design / Explanation

VPC: Single VPC providing address space for all subnets and routing control.

Public Subnets: Two subnets hosting internet-facing resources (EC2, NAT Gateway). They have route to the Internet Gateway (IGW).

Private Subnets: Two subnets hosting private resources (databases or applications). They use a NAT Gateway in a public subnet for outbound internet access.

Internet Gateway (IGW): Attached to VPC to enable internet access for public subnets.

NAT Gateway: Placed in a public subnet to allow outbound internet access for private subnets while keeping them unreachable from the internet.

Route Tables:

Public route table: 0.0.0.0/0 -> igw (associated with public subnets)

Private route table: 0.0.0.0/0 -> nat-gateway (associated with private subnets)

Subnet CIDR Ranges
Subnet	CIDR Block	Notes
VPC	10.0.0.0/16	Plenty of address space for multiple /24 subnets
Public Subnet A (AZ1)	10.0.1.0/24	Internet-facing resources
Public Subnet B (AZ2)	10.0.2.0/24	Internet-facing resources
Private Subnet A (AZ1)	10.0.11.0/24	Private resources (outbound via NAT)
Private Subnet B (AZ2)	10.0.12.0/24	Private resources (outbound via NAT)

---

**Screenshots / Diagrams**  
## VPC Overview
![VPC Overview](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/1.%20Networking%20%26%20Subnetting%20(AWS%20VPC%20Setup)Task/vpc.png)
![VPC Overview](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/1.%20Networking%20%26%20Subnetting%20(AWS%20VPC%20Setup)Task/vpc2.png)
## Internet GateWay
![Internet GateWayt](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/1.%20Networking%20%26%20Subnetting%20(AWS%20VPC%20Setup)Task/igw.png)  
## Route Tables
![Route Tables & Associations](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/1.%20Networking%20%26%20Subnetting%20(AWS%20VPC%20Setup)Task/route%20table.png)    

---

## Task 2: EC2 Static Website Hosting

**Requirements**

- Launch an EC2 instance (free-tier / minimal cost) in a public subnet  
- Install and configure Nginx (or another web server)  
- Host a static website (e.g. a simple HTML page or project portfolio)  
- Ensure website is accessible via public IP on port 80  
- Apply basic security: security groups, minimal open ports

---

## Instance Setup

AMI: Amazon Linux 2023 (Free Tier eligible)

Instance Type: t2.micro (Free Tier)

Subnet: Launched in Public Subnet A (10.0.1.0/24)

Public IP: Auto-assign enabled

Security Group:

SSH (22) allowed from your IP only (<YOUR_IP>/32)

HTTP (80) allowed from all (0.0.0.0/0)

Key Pair: Used for SSH access, stored locally (not in repo)

Nginx Installation (via user-data)

On instance launch, user-data script installs Nginx (dnf install -y nginx)

Creates /usr/share/nginx/html/index.html with your resume content

Starts and enables Nginx service

Basic Hardening Steps

Restrict SSH to your IP only (via Security Group)

Disable SSH password authentication (key-based only)

Keep system updated (dnf update -y)

Use least-privilege IAM users with MFA

Do not store private key in code or public repos

Set file permissions for index.html: chmod 644

---

**Evidence / Screenshots**  

## EC2 Instance Details
![EC2 Instance Details](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/2.EC2%20Static%20Website%20HostingTask/ec2.png) 
## Security Groups Configuration
![Security Groups Configuration](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/2.EC2%20Static%20Website%20HostingTask/securitygroup.png)
## Website Running – Browser Screenshot
![Website Running – Browser Screenshot](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/2.EC2%20Static%20Website%20HostingTask/resume%20web.png)  

---

## Task 5: AWS Architecture Diagram (draw.io / Design)

**Overview**

Create a comprehensive AWS architecture design for a scalable web application — multi-tier network (public + private), ALB, Auto-Scaling, DB / cache layer, security controls, monitoring/observability, etc.

**Diagram**  

## AWS Architecture Diagram
![AWS Architecture Diagram](https://github.com/Yug-Kapri/Flentos-aws-tasks/blob/8cdbcedc1906f11ce22cfc766f61c745e894cd8d/5.%20AWS%20Architecture%20Diagram%20(draw.io)Task/aws-architecture.jpg)  

---


## Cleanup & Cost Advice

After verifying your setup or demo:  
- Terminate EC2 instances  
- Delete Load Balancers, Target Groups, Auto-Scaling Groups  
- Remove NAT Gateways  
- Delete extra resources (subnets, VPC) if not needed  

This helps avoid ongoing billing from unused resources.
