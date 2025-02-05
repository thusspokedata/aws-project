# 🚀 Deployment Challenges & Solutions

## 📍 Project Overview
This repository documents the challenges and solutions encountered while deploying a **scalable web application** with:

- 🏗 **Backend:** NestJS
- 🎨 **Frontend:** Next.js
- 📦 **Image Storage:** Cloudinary (possible migration to AWS S3)
- ☁️ **Infrastructure:** AWS (EC2, RDS, Load Balancer)
- 🐳 **Containerization:** Docker & Docker Compose
- 🔄 **Horizontal Scaling:** Auto Scaling Groups (ASG) with EC2 instances

---

## 🔥 **Challenge #1: How to Handle Horizontal Scaling?**
### 🎯 **Goal**
Each new instance should come **pre-configured** with the application already running.

### 💡 **Solution**
1. **Dockerize the application**  
   - Create a **Dockerfile** (or **docker-compose.yml**) to containerize both the backend and frontend.
   - Push the image to **Docker Hub**.

2. **Automate instance setup**  
   - Use **EC2 user data** to pull the Docker image and start the containers when a new instance is launched.

3. **Auto Scaling**  
   - Configure **AWS Auto Scaling Groups (ASG)** to spin up new instances when traffic increases.
   - Use an **Application Load Balancer (ALB)** to distribute traffic among instances.

---

## 🔥 **Challenge #2: Connection Issues with AWS RDS**
### 🎯 **Problem**
When deploying on AWS, the backend **couldn’t connect** to the PostgreSQL RDS instance.

### 🔍 **Diagnosis**
- The RDS instance was in a **private subnet**, blocking external access.
- Security groups **did not allow inbound connections** from the EC2 instance.

### 💡 **Solution**
1. Modify the **RDS Security Group** to allow **PostgreSQL (port 5432)** from the EC2 instance.
2. Ensure the **EC2 instance is in the same VPC** as RDS.
3. Use **VPC Peering or NAT Gateway** if needed.

---

## 🔥 **Challenge #3: Cloudinary Upload Issues**
### 🎯 **Problem**
Image uploads to **Cloudinary** failed only on the AWS EC2 instance, but worked locally.

### 🔍 **Diagnosis**
- Cloudinary returned `401 Unauthorized` or `400 Bad Request`.
- The error **didn’t appear locally**, only in production.
- A missing **Upload Preset** was required on AWS but not locally.

### 💡 **Solution**
1. **Explicitly set the upload preset** in the request when running on AWS.
2. Ensure **Cloudinary API credentials** are correctly passed via environment variables.
3. Debug API connectivity using:

   ```sh
   curl -I https://api.cloudinary.com/v1_1/$CLOUDINARY_CLOUD_NAME/image/upload
   ```

## 🔥 **Challenge #4: Docker Image Architecture Mismatch**

### 🎯 **Problem**
When running `docker-compose up` on EC2, the container failed with:

```
image with reference docker.io/thusspokedata/kooben-be:1.0.1 was found but does not match the specified platform: wanted linux/amd64, actual: linux/arm64/v8
```

### 💡 **Solution**
1. **Ensure multi-architecture support** by building images with:

   ```sh
   docker buildx build --platform linux/amd64,linux/arm64 -t thusspokedata/kooben-be:latest --push .
   ```

2. If running on **an ARM-based EC2 instance**, ensure that the Docker image matches the architecture.

---

## 🔥 **Challenge #5: Port Already in Use**

### 🎯 **Problem**
Running `docker-compose up` resulted in:

```
Bind for 0.0.0.0:3000 failed: port is already allocated
```

### 💡 **Solution**
1. Check which process is using the port:
   ```sh
   sudo lsof -i :3000
   ```

2. Stop the conflicting process:
   ```sh
   sudo kill -9 <PID>
   ```
   or restart Docker:
   ```sh
   sudo systemctl restart docker
   ```

3. Ensure no old containers are running:
   ```sh
   docker ps -a
   docker rm -f <CONTAINER_ID>
   ```

---

## 🔥 **Challenge #6: Cloudinary Authentication Issues**

### 🎯 **Problem**
On the EC2 instance, API requests to Cloudinary failed with:

```
X-Cld-Error: cloud_name is disabled
```

Or:

```
Upload preset must be specified when using unsigned upload
```

### 💡 **Solution**
1. Check if Cloudinary credentials are correctly set in the container:
   ```sh
   docker exec -it koobenApp-dockereando env | grep CLOUDINARY
   ```
   If they are missing, update the `.env` file and restart the container.

2. Ensure that the **upload preset** is properly configured in Cloudinary.
   - Go to **Cloudinary Dashboard** → **Settings** → **Upload** → **Unsigned Uploading**.
   - Enable it and add the preset to your `.env` file:
     ```sh
     CLOUDINARY_UPLOAD_PRESET=your_preset_name
     ```

3. Validate API connectivity:
   ```sh
   curl -I https://api.cloudinary.com/v1_1/$CLOUDINARY_CLOUD_NAME/image/upload
   ```
   If authentication errors persist, generate **new API keys** in Cloudinary and update your `.env` file.

---

## 🚀 **Next Steps**
- Improve **horizontal scaling** by integrating Auto Scaling Groups (ASG) with a Load Balancer.
- Replace Cloudinary with **AWS S3** for image storage if necessary.
- Automate deployment by using **Terraform** or **AWS CDK**.



