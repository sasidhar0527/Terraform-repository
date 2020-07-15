resource "aws_instance" "myec2" {
  ami               = "ami-0e9089763828757e1"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"
}
