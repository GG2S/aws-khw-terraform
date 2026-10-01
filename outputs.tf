output "ec2_instance_id" {
  description = "Python API 서버 EC2 인스턴스 ID"
  value       = aws_instance.api_server.id
}

output "ec2_public_ip" {
  description = "Python API 서버 공인 IP"
  value       = aws_instance.api_server.public_ip
}

output "ssh_command" {
  description = "Amazon Linux 2023 EC2 SSH 접속 명령 예시"
  value       = "ssh -i <PRIVATE_KEY_PATH> ec2-user@${aws_instance.api_server.public_ip}"
}

output "api_url" {
  description = "3~4일 차에 FastAPI를 배포한 뒤 사용할 API 주소"
  value       = "http://${aws_instance.api_server.public_ip}:${var.api_port}"
}

output "dynamodb_table_name" {
  description = "FastAPI에서 사용할 DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.todos.name
}
