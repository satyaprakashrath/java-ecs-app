# Java Spring Boot App on AWS ECS with RDS PostgreSQL

This project demonstrates deploying a Java Spring Boot application using Docker to AWS ECS (Fargate) with RDS PostgreSQL, using Terraform for infrastructure provisioning.

---

## ✅ Prerequisites

- AWS CLI installed: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
- Terraform installed: https://developer.hashicorp.com/terraform/downloads
- Docker installed and running: https://docs.docker.com/get-docker/
- Java 17 installed
- Maven installed (or use Maven wrapper)
- Git installed

---

## 🧰 Step 1: AWS Profile Setup

Configure your AWS CLI credentials:

```bash
aws configure --profile myawsprofile
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
```
# Export your profile for current shell session:
```
export AWS_PROFILE=myawsprofile
```
# (Optional) Add it permanently:
```
echo 'export AWS_PROFILE=myawsprofile' >> ~/.bashrc
source ~/.bashrc
```

# Step 2: Build and Push Docker Image to AWS ECR
```bash
export REGION=$(aws configure get region)
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export REPO_NAME=java-ecs-app
```
## Create the ECR repository:
```bash
aws ecr create-repository --repository-name $REPO_NAME
```
## Authenticate Docker to ECR:

```bash
aws ecr get-login-password --region $REGION \
  | docker login --username AWS \
  --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com
```
## Build, tag, and push the Docker image:
```bash
docker build -t $REPO_NAME .

docker tag $REPO_NAME:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest

docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPO_NAME}:latest
```
# Step 3: Deploy Infrastructure Using Terraform
Navigate to the terraform directory (where your .tf files are):
```bash
cd terraform
``` 
## Initialize, Preview, and Apply Terraform Configuration:

```bash
terraform init
terraform plan
terraform apply
```
# Step 4: Access the Application
After deployment, open your browser and access:
```bash
POST
curl -X POST http://<load-balancer-dns>/api/users \
  -H "Content-Type: application/json" \
  -d '{"username":"satya", "email":"satya@example.com"}'

GET
curl http://<load-balancer-dns>/api/users

```

# Step 5: Cleanup
To clean up resources created by Terraform, run:

```bash
terraform destroy
```




# java-ecs-app
