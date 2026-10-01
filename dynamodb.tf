resource "aws_dynamodb_table" "todos" {
  name         = "${var.project_name}-todos"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "todo_id"

  attribute {
    name = "todo_id"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-todos"
  }
}
