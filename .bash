#!/bin/bash
set -e

# 1. Update packages and install Docker
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io unzip

# 2. Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# 3. Install AWS CLI (official method)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# 4. Install Docker Compose
DOCKER_COMPOSE_VERSION="2.20.2"
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 5. Create application directories
mkdir -p /home/ubuntu/app/backend
mkdir -p /home/ubuntu/app/frontend

# 6. Define the S3 bucket
AWS_BUCKET="cf-templates-10608x4j4e39v-eu-central-1"

# 7. Download backend files from S3
cd /home/ubuntu/app/backend
aws s3 cp s3://$AWS_BUCKET/docker-compose.yml .
aws s3 cp s3://$AWS_BUCKET/.env .

# 8. Download frontend files from S3
cd /home/ubuntu/app/frontend
aws s3 cp s3://$AWS_BUCKET/docker-compose-fe.yaml .
aws s3 cp s3://$AWS_BUCKET/.env.local .

# Rename the files to match expected names
mv docker-compose-fe.yaml docker-compose.yaml
mv .env.local .env

# 9. Set proper permissions and load environment variables
chmod 600 /home/ubuntu/app/backend/.env
chmod 600 /home/ubuntu/app/frontend/.env

export $(grep -v '^#' /home/ubuntu/app/backend/.env | xargs)
export $(grep -v '^#' /home/ubuntu/app/frontend/.env | xargs)

# 10. Start the containers with the latest version of the image
cd /home/ubuntu/app/backend
docker-compose up -d --build

cd /home/ubuntu/app/frontend
docker-compose up -d --build
