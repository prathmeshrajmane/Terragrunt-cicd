resource "aws_instance" "example" {
  ami           = "ami-06b09bfacae1453cb"
  instance_type = "t2.micro"
  tags = {
    Name = var.instance_name
  }
}
