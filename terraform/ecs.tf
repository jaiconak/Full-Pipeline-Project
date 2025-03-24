resource "aws_ecs_cluster" "lightfeatherEcsCluster" {
    name = "lightfeather-ecs-cluster"
}

resource "aws_ecs_task_definition" "backend" {
    family = "backend"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecsRole.arn
    


    container_definitions = jsonencode([
        {
            name = "backend"
            image = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-backend:v3"
            essential = true
            portMappings = [
                {
                    containerPort = 8080
                    hostPort = 8080
                }
            ]
            
        }
    ])
}


resource "aws_ecs_task_definition" "frontend" {
    family = "frontend"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecsRole.arn
    
    container_definitions = jsonencode([
        {
            name = "frontend"
            image = "039612867339.dkr.ecr.us-east-1.amazonaws.com/lightfeather-frontend:v3"
            essential = true
            portMappings = [
                {
                    containerPort = 3000
                    hostPort = 3000
                }
            ]
            
        }
    ])
}

resource "aws_ecs_service" "backendService" {
    name = "backend-service"
    cluster = aws_ecs_cluster.lightfeatherEcsCluster.id
    task_definition = aws_ecs_task_definition.backend.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]
      security_groups = [aws_security_group.ecsSG.id]
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.backend.arn
      container_name = "backend"
      container_port = 8080

    }

    depends_on = [ 
        aws_lb_listener_rule.backendRule
    ]
}

resource "aws_ecs_service" "frontendService" {
    name = "frontend-service"
    cluster = aws_ecs_cluster.lightfeatherEcsCluster.id
    task_definition = aws_ecs_task_definition.frontend.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]
      security_groups = [aws_security_group.ecsSG.id]
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.frontend.arn
      container_name = "frontend"
      container_port = 3000

    }

    depends_on = [ 
        aws_lb_listener.defaultFrontEnd
    ]
}