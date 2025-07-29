# This Terraform config creates an IAM Role that GitHub Actions can assume using OIDC
# It allows GitHub Actions to deploy infrastructure and push images to ECR

resource "aws_iam_role" "github_actions_oidc_role" {
  name = "github-actions-deploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::840741414500:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:<your_github_org_or_user>/<repo_name>:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  description = "OIDC role assumed by GitHub Actions for CI/CD"
}

resource "aws_iam_role_policy" "github_actions_policy" {
  name = "github-actions-policy"
  role = aws_iam_role.github_actions_oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "logs:*",
          "iam:PassRole",
          "elasticloadbalancing:*",
          "cloudwatch:*",
          "ec2:Describe*",
          "ssm:GetParameters",
          "rds:Describe*",
          "rds:List*"
        ],
        Resource = "*"
      }
    ]
  })
}
