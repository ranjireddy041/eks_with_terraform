terraform {
  backend "s3" {
    bucket = "ranjith-devops-terraform-bucket-001"
    key    = "todo-app/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = "true"
  }
}
