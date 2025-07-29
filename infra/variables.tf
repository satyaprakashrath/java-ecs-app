variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "us-west-2"
}

variable "project_name" {
    description = "The name of the project"
    type        = string
    default     = "java-ecs-app"
}

variable "db_username" {
    description = "The username for the PostgreSQL database"
    type        = string
    default     = "postgres"
}

variable "db_password" {
    description = "The password for the PostgreSQL database"
    type        = string
    sensitive = true
}