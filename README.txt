README
1. Overview

This repository contains the Lightfeather DevOps Coding Challenge solution, featuring:

- A Node.js backend (Express)

- A React frontend.

Both applications are Dockerized and pushed to AWS ECR for future deployment on ECS.

2. Prerequisites

Node.js v16 (challenge tested with Node 16)

Docker (for container builds)

AWS CLI configured (for pushing images to ECR)

3. Local Development & Testing
Clone the Repo:

git clone https://github.com/Team-LightFeather/devops-code-challenge.git
cd devops-code-challenge

Install Dependencies & Start the Backend:

cd backend
npm ci
npm start
Verifies the backend is running at http://localhost:8080.

Install Dependencies & Start the Frontend:

cd frontend
npm ci
npm start
Frontend runs at http://localhost:3000 and confirms successful fetch from the backend

4. Dockerization
Dockerfiles:
Ensured that for both Frontend and Backend Application it had a Dockerfile that:

- Uses a Node 16 base image

- Copies package*.json, runs npm ci

- Copies source code

- Exposes the correct port (8080 for backend, 3000 for frontend)

- Sets CMD ["npm", "start"]

# Backend
cd backend
docker build -t lightfeather-backend .

# Frontend
cd frontend
docker build -t lightfeather-frontend .

5. After building Docker images locally for both the backend and frontend, I tagged each image with a v1 version and pushed them to their respective private ECR repositories (lightfeather-backend and lightfeather-frontend). I authenticated Docker with AWS ECR using the AWS CLI and used versioned image tags to maintain clarity throughout the deployment process. This allows ECS to pull the appropriate version of each image during service deployment.
