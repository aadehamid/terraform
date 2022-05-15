provider "aws"{
    region = "us-east-1"
    }
resource "aws_instance" "hashi_test_instance"{
    ami = "ami-0022f774911c1d690"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data = <<-EOF
                                #!/bin/bash
                                echo "Hello, World" > index.html
                                nohup busybox httpd -f -p 8080 &
                                EOF
    tags = {"name'": "instance_to_test_hashi"}
}
resource "aws_security_group" "instance"{
    name="terraform-example-instance"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
