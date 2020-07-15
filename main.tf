#---------------------- VPC --------------#
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = var.vpc_name
    Owner = "Sasi"
  }
}

#-------------------- IGW ------------------#

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "${var.IGW_name}"
  }
}
#------------------------ Subnet --------------#
resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.public_subnet1_name
  }
}
#----------------------------------------------------#
resource "aws_subnet" "subnet2-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet2_cidr}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.public_subnet2_name}"
  }
}

#--------------------------------------------------------#
resource "aws_subnet" "subnet3-public" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet3_cidr}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.public_subnet3_name}"
  }

}

#-------------------- Security Group -----------#
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#---------------------  EC2 ------------------#
resource "aws_instance" "web-1" {
  #ami = "${data.aws_ami.my_ami.id}"
  ami               = "ami-0e9089763828757e1"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"

  #key_name = "LaptopKey"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "Sasi"
    CostCenter = "ABDV"
  }
}

#---------------------  EC2 ------------------#
resource "aws_instance" "web-2" {
  #ami = "${data.aws_ami.my_ami.id}"
  ami               = "ami-0e9089763828757e1"
  availability_zone = "us-east-1b"
  instance_type     = "t2.micro"

  #key_name = "LaptopKey"
  subnet_id                   = aws_subnet.subnet2-public.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-2"
    Env        = "test"
    Owner      = "Sasi"
    CostCenter = "AZSA"
  }
}

#------------------- S3 Bucket --------------#

resource "aws_s3_bucket" "Terrform_bucket" {
  bucket = "my-test-terraform-0577"
  acl    = "private"
  force_destroy = "true"

  tags = {
    Name        = "Terraform Bucket"
    Environment = "Dev-Env"
  }

  versioning {
    enabled = true
  }
}

#-------------------- OutPuts --------------#

output "My_VPC_Name" {

  value = "${aws_vpc.default.tags.Name}"

}

output "MY_VPC_ID" {

  value = "${aws_vpc.default.id}"

}

output "MY_TestServer_Name" {

  value = "${aws_instance.web-1.tags.Name}"
}


#-------------------S3 Backend ------------#
/*
#terraform {
#  backend "s3" {
#    bucket = "my-test-terraform-0577"
#    key    = "terraform.tfstate"
#    region = "us-east-1"
#  }
#}
*/

#-------------------- ALB --------------------------#
/*
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_all.id}"]
  subnets            = ["${aws_subnet.subnet1-public.id}","${aws_subnet.subnet2-public.id}", "${aws_subnet.subnet3-public.id}" ]

  enable_deletion_protection = true

#  access_logs {
#    bucket  = "${aws_s3_bucket.lb_logs.bucket}"
#    prefix  = "test-lb"
#    enabled = true
#  }

  tags = {
    Name = "Terraform ALB"
    Environment = "production"
  }
}
*/
#---------------- Target Groups--------------------------#
/*
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.test.id}"
  port              = "${var.host_port}"
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = "${aws_lb_target_group.testinggggg527.id}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "testinggggg527" {
  name = "{var.ecs_name}-ALB_TG"
  port = "${var.host_port}"
  protocol = "${var.aws_alb_protocol}"
  vpc_id = "${aws_vpc.default.id}"
  #depends_on = "${aws_lb.test}"

  health_check {
    path  = "/"
    healthy_threshold = 2
    unhealthy_threshold = 10
    timeout = 60
    interval = 300
    matcher = "200,301,302"
}

tags = {
   Name = "Terraform Target Group"
   Environment = "production"
}
}

*/

