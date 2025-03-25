terraform {
  backend "s3" {
    bucket         = "lightfeather-proj"
    key            = "dev/terraform.tfstate" #This is where the path where terraform stores the statefile 
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}