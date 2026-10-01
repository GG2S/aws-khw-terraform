resource "aws_security_group" "api_server" {
  name        = "${var.project_name}-api-sg"
  description = "Security group for the FastAPI EC2 server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-api-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.api_server.id
  description       = "SSH from the operator public IP"
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "api" {
  security_group_id = aws_security_group.api_server.id
  description       = "Public access to the FastAPI service"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.api_port
  to_port           = var.api_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.api_server.id
  description       = "Allow outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
