resource "aws_lb" "alb" {
    name = "lightfeather-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.albSG.id]
    subnets = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]

    tags = {
      Name = "lightfeather-alb"
    }
}

resource "aws_lb_target_group" "frontend" {
    name = "lightfeather-frontend-tg"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.projVpc.id
    target_type = "ip"

    health_check {
    path     = "/"
    protocol = "HTTP"
  }
    
    tags = {
      Name = "lightfeather-frontend-tg"
    }
  
}

resource "aws_lb_target_group" "backend" {
  name = "lightfeather-backend-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.projVpc.id
  target_type = "ip"

  health_check {
    path = "/"
    protocol = "HTTP"
  }

  tags = {
    Name = "lightfeather-backend-tg"
  }
}

resource "aws_lb_listener" "defaultFrontEnd" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

}

resource "aws_lb_listener_rule" "backendRule" {
  listener_arn = aws_lb_listener.defaultFrontEnd.arn
  priority = 10
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}