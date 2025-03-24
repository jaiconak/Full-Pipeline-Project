data "aws_iam_policy_document" "ecsAssumeRole" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
        type = "Service"
        identifiers = ["ecs-tasks.amazonaws.com"]
      }
    } 
}

resource "aws_iam_role" "ecsRole" {
    name = "lightfeather-ecs-role"
    assume_role_policy = data.aws_iam_policy_document.ecsAssumeRole.json
}

resource "aws_iam_role_policy_attachment" "ecsPolicyAttach" {
    role = aws_iam_role.ecsRole.name
    policy_arn = var.ecsPolicy
}