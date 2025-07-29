resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/java-ecs-app"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "java_app" {
  family                   = "java-ecs-app-family-2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "java-ecs-app"
      image     = "840741414500.dkr.ecr.us-west-2.amazonaws.com/java-ecs-app:latest" # <- auto linked to ECR repo
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:postgresql://${aws_db_instance.postgres_db.address}:5432/demo"
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = "postgres"
        },
        {
          name  = "SPRING_DATASOURCE_PASSWORD"
          value = var.db_password
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/java-ecs-app"
          awslogs-region        = "us-west-2"
          awslogs-stream-prefix = "ecs-v2"
        }
      }
    }
  ])
  depends_on = [
    aws_cloudwatch_log_group.ecs_logs
  ]

  lifecycle {
    create_before_destroy = true
  }
}
