resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}






resource "aws_instance" "web-1" {

    ami = lookup(var.imagename,var.region)
    #ami = "ami-0d857ff0f5fc4e03b"
    #ami = "${data.aws_ami.my_ami.id}"
    instance_type = "t2.micro"
    key_name = "splunk"
    subnet_id = aws_subnet.subnets.0.id
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    tags = {
        Name = "httpd"

    }

}


resource "null_resource" "ssh_connection" {
depends_on = [aws_instance.web-1]



connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key  = file("splunk.pem")
    host        = aws_instance.web-1.public_ip
 }

provisioner "file" {
  source      = "web.sh"
  destination = "/home/ubuntu/web.sh"

  }


provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/ubuntu/web.sh",
      "sh /home/ubuntu/web.sh",
      "mkdir ok",


    ]
}
provisioner "file" {
  source      = "script.sh"
  destination = "/home/ubuntu/script.sh"

  }


provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/ubuntu/script.sh",
      "sh /home/ubuntu/script.sh",
      


    ]
}

}

