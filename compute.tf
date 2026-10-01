resource "aws_key_pair" "operator" {
  key_name   = "${var.project_name}-key"
  public_key = trimspace(var.ssh_public_key)
}

resource "aws_instance" "api_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.api_server.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.operator.key_name
  iam_instance_profile        = aws_iam_instance_profile.api_server.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-api-server"
  }

  depends_on = [
    aws_iam_role_policy_attachment.dynamodb_access,
    aws_route_table_association.public
  ]
}
