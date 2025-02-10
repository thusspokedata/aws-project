#!/bin/bash
set -e

# 1. Update packages and install Docker
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io unzip postgresql-client postgresql-client-14

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

# 5. Create application directory and navigate to it
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# 6. Download required files from S3
AWS_BUCKET="cf-templates-10608x4j4e39v-eu-central-1"
aws s3 cp s3://$AWS_BUCKET/docker-compose.yml .
aws s3 cp s3://$AWS_BUCKET/.env .

# 7. Set proper permissions and load environment variables
chmod 600 .env
export $(grep -v '^#' .env | xargs)

# 8. Start the containers with the latest version of the image
docker-compose up -d --build