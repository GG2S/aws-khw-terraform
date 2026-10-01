variable "project_name" {
  description = "리소스 이름과 태그에 사용할 프로젝트 이름"
  type        = string
  default     = "todo-api"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name은 영문 소문자, 숫자, 하이픈만 사용할 수 있습니다."
  }
}

variable "aws_region" {
  description = "AWS 리소스를 생성할 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public Subnet IPv4 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Python API 서버용 EC2 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

variable "api_port" {
  description = "Uvicorn/FastAPI가 외부 요청을 받을 포트"
  type        = number
  default     = 8000
}

variable "allowed_ssh_cidr" {
  description = "SSH 접속을 허용할 공인 IP CIDR. 예: 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrhost(var.allowed_ssh_cidr, 0))
    error_message = "allowed_ssh_cidr에는 유효한 IPv4 CIDR을 입력해야 합니다."
  }
}

variable "ssh_public_key" {
  description = "EC2 Key Pair로 등록할 SSH 공개키의 전체 내용"
  type        = string
}
