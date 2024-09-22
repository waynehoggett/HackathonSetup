# Pre-reqs

New-Item -Path "C:\" -Name "Terraform" -ItemType Directory -ErrorAction SilentlyContinue
Set-Location -Path "C:\Terraform"

#1

choco install terraform -y
choco install azure-cli -y
code --install-extension HashiCorp.terraform

Read-Host -Prompt "Verify and Continue and then Press Enter"
# 2
Write-Host "Starting Challenge 2"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/terraform-basics/solutions/2/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

Read-Host -Prompt "Verify and Continue and then Press Enter"

# 3
Write-Host "Starting Challenge 3"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/waynehoggett/HackathonSetup/refs/heads/main/terraform-basics/solutions/3/main.tf" -OutFile "C:\Terraform\main.tf" -UseBasicParsing

terraform init

Read-Host -Prompt "Verify and Continue and then Press Enter"
