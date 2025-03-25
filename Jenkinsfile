// TODO
// Check out your repository (which contains backend/, frontend/, terraform/).

// Build Docker images for your backend and frontend (using the Dockerfiles in each subfolder).

// Push those images to your AWS ECR repository (so ECS can pull them).

// Run Terraform in your terraform/ folder to update the ECS services with the new images.

// Optionally, handle any environment variables or credentials for AWS, ECR, etc.

pipeline {
    agent any

    environment {
        FRONTEND_ECR_REPO = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend"
        BACKEND_ECR_REPO = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend"
        BRANCH_NAME = "main"
        GIT_CRED = "github-cred"
        PROJECT_URL = "https://github.com/jaiconak/lightfeather-proj.git"

    }

    stages {

        stage('Git Checkout'){
            steps{
                git branch: "${BRANCH_NAME}", credentialsId: "${GIT_CRED}", \
                url: "${PROJECT_URL}"
                sh 'echo "You checked out the repo"'
            }
        }

        stage ('ECR login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-cred', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]){
                sh '''

                aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 039612867339.dkr.ecr.us-east-1.amazonaws.com

                '''
            }
            }
        }

        //Front End

        stage ('Docker Build Front End') {
            steps {
                sh "docker build -t lightfeather-frontend:${BUILD_NUMBER} ./frontend"
            }
        }

        stage ('Docker Tag Front End') {
            steps {
                sh "docker tag lightfeather-frontend:${BUILD_NUMBER} $FRONTEND_ECR_REPO:${BUILD_NUMBER}"
            }
        }

        stage ('Docker Push Front End') {
            steps {
                sh "docker push $FRONTEND_ECR_REPO:${BUILD_NUMBER}"
            }
        }

        //Back end
        stage ('Docker Build Back End') {
            steps {
                sh "docker build -t lightfeather-backend:${BUILD_NUMBER} ./backend"
            }
        }

        stage ('Docker Tag Back End') {
            steps {
                sh "docker tag lightfeather-backend:${BUILD_NUMBER} $BACKEND_ECR_REPO:${BUILD_NUMBER}"
            }
        }

        stage ('Docker Push Back End') {
            steps {
                sh "docker push $BACKEND_ECR_REPO:${BUILD_NUMBER}"
            }
        }

        stage ('Terraform Deploy') {
            steps {
                sh """
                cd terraform 
                terraform init -reconfigure

                terraform plan -out=planfile \
                -var 'backendImageUri=${BACKEND_ECR_REPO}:${BUILD_NUMBER}' \
                -var 'frontendImageUri=${FRONTEND_ECR_REPO}:${BUILD_NUMBER}'

                terraform apply -auto-approve planfile
                """
            }
        }
    
}
}