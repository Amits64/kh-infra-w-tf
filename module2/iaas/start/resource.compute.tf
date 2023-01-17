# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.id
  # put this server in subnet in zone a
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.server.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y && sudo apt install -y nginx
  echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOF

  tags = {
    Name = "server1"
  }

  volume_tags = {
    Name = "server1"
  }
}
resource "aws_instance" "server2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh_key.id
  # put this server in subnet in zone c
  subnet_id              = aws_subnet.public_c.id
  vpc_security_group_ids = [aws_security_group.server.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y && sudo apt install -y nginx
  echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  EOF

  tags = {
    Name = "server2"
  }

  volume_tags = {
    Name = "server2"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "ssh_key" {
  key_name   = "iaas-start"
  public_key = data.local_file.public_key.content
}
# https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file
data "local_file" "public_key" {
  filename = "${path.module}/ec2_rsa.pub"
}
