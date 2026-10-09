data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_security_group" "legacy_ssh_sg" {
  name        = "${var.server_name}-ssh-sg"
  description = "Allow SSH access to the legacy migration Ubuntu server"

  ingress {
    description = "SSH from approved public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  ingress {
    description = "Allow HTTP traffic"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.http_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.server_name}-ssh-sg"
  }
}
resource "aws_instance" "legacy_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.legacy_ssh_sg.id]

  tags = {
    Name = var.server_name
  }
}

resource "aws_network_acl_rule" "allow_http_inbound" {
  network_acl_id = var.network_acl_id
  rule_number    = var.http_nacl_rule_number
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.http_cidr
  from_port      = var.http_port
  to_port        = var.http_port
}

resource "aws_eip" "legacy_server_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.server_name}-eip"
  }
}

resource "aws_eip_association" "legacy_server_eip_assoc" {
  instance_id   = aws_instance.legacy_server.id
  allocation_id = aws_eip.legacy_server_eip.id
}