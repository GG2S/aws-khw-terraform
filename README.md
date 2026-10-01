# Terraform Day 2 — AWS 기본 인프라

이 디렉터리는 5일 프로젝트의 2일 차 범위를 구현합니다.

## 생성되는 리소스

- VPC 및 Public Subnet
- Internet Gateway, Public Route Table, 연결(Association)
- SSH(22) 및 FastAPI(기본 8000) 접근용 Security Group
- Amazon Linux 2023 EC2와 SSH Key Pair
- DynamoDB 테이블(`todo_id` 문자열 Partition Key, On-demand 과금)
- EC2가 해당 DynamoDB 테이블만 CRUD할 수 있는 IAM Role/Policy/Instance Profile

## 사전 준비

1. Terraform CLI와 AWS CLI를 설치합니다.
2. AWS IAM 자격 증명을 로컬에 설정합니다.

   ```powershell
   aws configure
   aws sts get-caller-identity
   ```

3. SSH 키가 없다면 Windows PowerShell에서 생성합니다.

   ```powershell
   ssh-keygen -t ed25519 -f $HOME\.ssh\todo-api
   ```

4. 변수 예시 파일을 실제 변수 파일로 복사합니다.

   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```

5. 자신의 공인 IP와 공개키를 확인하여 `terraform.tfvars`를 수정합니다.

   ```powershell
   (Invoke-RestMethod -Uri "https://checkip.amazonaws.com").Trim()
   Get-Content $HOME\.ssh\todo-api.pub
   ```

   공인 IP가 `1.2.3.4`라면 `allowed_ssh_cidr = "1.2.3.4/32"`처럼 입력합니다.
   `ssh_public_key`에는 `.pub` 파일의 한 줄 전체를 입력합니다. 개인키는 입력하거나 Git에 올리지 않습니다.

## 실행 순서

```powershell
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out day2.tfplan
terraform apply day2.tfplan
terraform output
```

`plan`에서 생성 대상과 리전이 맞는지 반드시 확인한 뒤 `apply`합니다. 성공 후에는 다음을 확인합니다.

```powershell
terraform state list
terraform output ec2_public_ip
terraform output dynamodb_table_name
```

EC2 SSH 접속 예시는 다음과 같습니다.

```powershell
ssh -i $HOME\.ssh\todo-api ec2-user@<EC2_PUBLIC_IP>
```

2일 차에는 FastAPI 코드를 아직 배치하지 않으므로 `api_url`은 접속되지 않는 것이 정상입니다. 3일 차에 애플리케이션을 작성하고 4일 차에 EC2에 배치합니다.

## 정리 및 비용 방지

실습을 중단하거나 검증을 마쳤다면 다음 명령으로 리소스를 제거합니다.

```powershell
terraform plan -destroy
terraform destroy
```

삭제 후 AWS 콘솔에서 EC2, VPC, DynamoDB, IAM 리소스가 남아 있지 않은지 확인합니다. `.tfstate`와 `terraform.tfvars`는 Git에 커밋하지 않습니다.
