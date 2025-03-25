1. Overview 
This repository contains the solution for the Lightfeather DevOps Coding Challenge. It demonstrates a complete end-to-end CI/CD pipeline and infrastructure deployment using industry best practices. The solution includes:

- Backend: A Node.js (Express) API.

- Frontend: A React application.

- Containerization: Both applications are Dockerized.

- Infrastructure as Code: AWS resources (ECS, ECR, ALB, VPC, etc.) are provisioned using Terraform.

- CI/CD Pipeline: Jenkins automates code checkout, Docker builds, image pushes to AWS ECR, and deployment updates via Terraform.

2. Prerequisites
Before you begin, ensure you have the following installed and configured:

Node.js v16 – The applications were tested with Node.js 16.

Docker – For building and running container images.

AWS CLI – Configured with the necessary credentials and permissions.

Terraform CLI – To provision and manage AWS infrastructure.

Jenkins – Deployed on an EC2 instance and accessible publicly for CI/CD automation.

3. Local Development & Testing
3.1 Clone the Repository
git clone https://github.com/Team-LightFeather/devops-code-challenge.git
cd devops-code-challenge

3.2 Running the Backend
cd backend
npm ci
npm start
The backend runs on http://localhost:8080.

3.3 Running the Frontend
cd frontend
npm ci
npm start
The frontend runs on http://localhost:3000 and should successfully fetch data from the backend.

4. Dockerization
Each application includes a Dockerfile that builds an image using Node.js v16:

Backend Dockerfile

Sets the working directory, installs dependencies via npm ci, copies the code, exposes port 8080, and runs npm start.

Frontend Dockerfile

Similar setup but exposes port 3000.

4.1 Building Docker Images
Build the images locally
# Backend
cd backend
docker build -t lightfeather-backend .

# Frontend
cd frontend
docker build -t lightfeather-frontend .

4.2 Pushing Images to AWS ECR
After building:

Tag the images:
docker tag lightfeather-backend:latest 039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend:v1
docker tag lightfeather-frontend:latest 039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend:v1

Authenticate with AWS ECR:
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 039612867339.dkr.ecr.us-east-1.amazonaws.com

Push the images:
docker push 039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend:v1
docker push 039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend:v1

5. Infrastructure Provisioning with Terraform -All AWS resources required for the application (ECS, ALB, VPC, etc.) are defined and managed via Terraform.
5.1 Deployment Steps
Initialize Terraform (ensuring the backend configuration is correct):
terraform init -reconfigure -force-copy -input=false

terraform plan -out=planfile \
  -var 'backendImageUri=039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend:v1' \
  -var 'frontendImageUri=039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend:v1'
  
terraform apply -auto-approve planfile
IMPORTANT: The Terraform configuration updates the ECS task definitions and services without altering existing critical resources (e.g., ALB DNS).

6. CI/CD Pipeline with Jenkins
Jenkins automates the entire deployment process:

- Source Control: Checks out the code from the Git repository.

- Docker Operations: Builds, tags, and pushes Docker images to AWS ECR.

- Terraform Deployment: Executes Terraform commands to update AWS ECS services with new image URIs.

- Pipeline Configuration: Refer to the included Jenkinsfile for detailed steps.

7. Deployment on AWS ECS
ECS Cluster: Both applications are deployed on AWS ECS using Fargate.

Load Balancer: The frontend is exposed via an Application Load Balancer (ALB) to the public internet.

State Management: The Terraform state is maintained in an S3 bucket and is kept in sync.

7.1 Accessing the Deployed Applications
Frontend URL:
Access your deployed application at the ALB DNS, e.g.,
http://lightfeather-alb-140455032.us-east-1.elb.amazonaws.com

Jenkins URL:
Jenkins is available at, e.g.,
http://98.80.210.120:8080/

8. Additional Information
Repository Sharing:
The GitHub repository is private and has been shared with codingchallenge-eval@lightfeather.io.

Notes:

The solution has been tested locally and deployed on AWS using Terraform and Jenkins.

The infrastructure is designed to be scalable and reproducible.

The S3 state file is maintained and up-to-date to ensure consistency.