provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-09d56f8956ab235b3"
  instance_type = "t2.micro"
  user_data = <<-EOF
  #!/bin/bash
  echo "Hello, World!" > index.html
  nohup busybox httpd -f -p ${var.server_port} &
  EOF

vpc_security_group_ids = [ aws_security_group.instance.id ]
  tags = {
      Name = "terraform-example"

  }
}

resource "aws_security_group" "instance" {
  name = var.security_group_name

  ingress {
      from_port = var.server_port
      to_port = var.server_port
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "security_group_name" {
  description = "The name of the security group"
  type = string
  default = "terraform-example-instance"
}

variable "server_port" {
  description = "The port of hte server we use for HTTP requests"
  type = number
  default = 8080
}
output "public_ip" {
    value = aws_instance.example.public_ip
    description = "The public IP of the web server"
}
