resource "local_file" "demo"{
    filename = "E:/EKS using Terraform/Demo/${var.filename}"
    content = var.content
}