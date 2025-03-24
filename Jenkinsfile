// TODO
// Check out your repository (which contains backend/, frontend/, terraform/).

// Build Docker images for your backend and frontend (using the Dockerfiles in each subfolder).

// Push those images to your AWS ECR repository (so ECS can pull them).

// Run Terraform in your terraform/ folder to update the ECS services with the new images.

// Optionally, handle any environment variables or credentials for AWS, ECR, etc.

pipeline {
    agent any

    environment {
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
        
    }
}