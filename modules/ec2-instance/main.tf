resource "aws_instance" "example" {
  ami           = "ami-06b09bfacae1453cb"
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
}
