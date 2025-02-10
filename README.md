# 🚀 AWS Final Project – Work in Progress

This project showcases key cloud architecture principles, automation, and scalability within AWS.

## 📌 Project Overview
The goal of this project is to build and deploy a **scalable, highly available, and automated application** using **AWS services**.

## 🏗️ Technologies & Services Used

- **Backend:** NestJS (Node.js framework) – Hosted on an EC2 instance with Docker  
- **Frontend:** Next.js (React framework) – Hosted on a separate EC2 instance with Docker  
- **Compute:** EC2 (Elastic Compute Cloud) with Auto Scaling Groups  
- **Load Balancer:** AWS Application Load Balancer (ALB) for backend and frontend  
- **Database:** PostgreSQL on Amazon RDS (Free Tier)  
- **Networking:** Private and public subnets for better security and internal communication  
- **Storage:** S3 (Planned for static file hosting)  
- **Monitoring & Logging:** AWS CloudWatch (Planned)  
- **Security:** IAM roles, VPC, and security groups restricting database access  
- **DNS Management:** AWS Route 53 – Custom domain for frontend, backend connects directly to ALB ARN  

## ⚙️ Features

✔️ **Scalable & Highly Available** – Backend and frontend run in separate EC2 instances with Load Balancer and Auto Scaling  
✔️ **Database Migration** – Moved from a local Postgres container to Amazon RDS for better scalability  
✔️ **Dockerized Deployment** – Backend and frontend are managed via Docker & Docker Compose  
✔️ **Internal Communication** – Backend connects to RDS using private networking  
✔️ **Security Best Practices** – Instances run in a VPC with restricted inbound rules for enhanced security  
✔️ **Automated Setup** – EC2 instances are provisioned via Launch Templates with required dependencies  
✔️ **Custom Domain Configuration** – Frontend is accessible via **Route 53**, backend is accessed internally via **ALB ARN**  

## 🚀 Deployment Process

1. **Infrastructure Setup:** EC2 instances are provisioned manually or via Launch Templates  
2. **Backend & Frontend Deployment:** Docker images are pulled from a registry (Docker Hub) and run on EC2  
3. **Database Connection:** Backend connects to Amazon RDS using environment variables  
4. **Auto Scaling & Load Balancing:** Traffic is distributed via AWS Application Load Balancer (ALB)  
5. **Frontend Routing:** Route 53 maps the domain to the frontend Load Balancer  
6. **Backend Communication:** The frontend interacts with the backend using the **ALB ARN**
