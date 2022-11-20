variable "aws_vpc_id" {
  type = string
}

provider "aws" {
  region = "us-east-1"
  profile = "default"
  shared_credentials_file = "/.aws/credentials"
}

resource "aws_instance" "prod" {
  instance_type = "t2.micro"
  ami = "ami-0915bcb5fa77e4892"
  key_name = aws_key_pair.user_ssh.key_name
  user_data = file("scripts/user-data.sh")

}

# vpc and security groups **************************************

data "aws_vpc" "default" {
  id = var.aws_vpc_id
}
resource "aws_security_group" "http_https" {
  name = "http_https"
  description = "Allows http and https traffics only"
  vpc_id = data.aws_vpc.default.id
  ingress {
    description = "Https from the internet"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      data.aws_vpc.default.cidr_block,
      "0.0.0.0/0"]
  }
  ingress {
    description = "http from the internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      data.aws_vpc.default.cidr_block,
      "0.0.0.0/0"]
  }
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id = aws_security_group.http_https.id
  network_interface_id = aws_instance.prod.primary_network_interface_id
}

resource "aws_key_pair" "user_ssh" {
  key_name = "ssh_instance_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
