resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
resource "aws_security_group" "ecs_sg" {
    vpc_id = aws_vpc.main.id
    name   = "${var.project_name}-ecs-sg"

    ingress {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project_name}-ecs-sg"
    }
}


resource "aws_ecs_service" "java_app_service" {

  name = "ecs-java-app-service"
  cluster = aws_ecs_cluster.java_app_cluster.id
  task_definition = aws_ecs_task_definition.java_app.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
      subnets = aws_subnet.public[*].id
      security_groups = [aws_security_group.ecs_sg.id]
      assign_public_ip = true
  }
  load_balancer {
      target_group_arn = aws_lb_target_group.app_tg.arn
      container_name   = "java-ecs-app"
      container_port   = 8080
  }
  deployment_controller {
    type = "ECS"
  }

  force_new_deployment = true
}