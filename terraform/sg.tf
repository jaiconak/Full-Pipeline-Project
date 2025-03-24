resource "aws_security_group" "albSG" {
  name = "ALB-SG"
  vpc_id = aws_vpc.projVpc.id
  description = "Allow HTTP & HTTPS"
  
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
        description = "allow all outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "ecsSG" {
    name = "ECS-SG"
    vpc_id = aws_vpc.projVpc.id
    description = "Allow ALB SG to access ECS tasks on 8080 (backend) and 3000 (frontend)"

    ingress {
        description = "Backend on port 8080"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        security_groups = [aws_security_group.albSG.id]
    }

     ingress {
        description = "Frontend on port 3000"
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        security_groups = [aws_security_group.albSG.id]
    }

    egress {
        description = "allow all outbound"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}