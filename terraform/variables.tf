variable "providerRegion" {
  description = "Region for Provider"
  default = "us-east-1"
}

variable "providerProfile" {
    description = "Which CLI account"
    default = "default"
}

variable "ecsPolicy" {
    description = "Needed ecs policies"
    default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "backendImageUri" {
    description = "Backend URI"
    default = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend:v3"
}

variable "frontendImageUri" {
    description = "Frontend URI"
    default = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend:v3"
    
  
}