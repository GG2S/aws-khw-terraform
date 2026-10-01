resource "aws_iam_role" "api_server" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.project_name}-dynamodb-policy"
  description = "Allow the Python API server to access its DynamoDB table"
  policy      = data.aws_iam_policy_document.dynamodb_access.json
}

resource "aws_iam_role_policy_attachment" "dynamodb_access" {
  role       = aws_iam_role.api_server.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_instance_profile" "api_server" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.api_server.name
}
