variable "aws_region" {
  description = "AWS region where the legacy system infrastructure will be created"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Ubuntu server"
  type        = string
}

variable "server_name" {
  description = "Name tag for the Ubuntu legacy migration server"
  type        = string
}

variable "key_name" {
  description = "AWS key pair used to SSH into the Ubuntu EC2 instance"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "Public IP address allowed to SSH into the Ubuntu server"
  type        = string
}

variable "network_acl_id" {
  description = "Network ACL associated with the Ubuntu server subnet"
  type        = string
}

variable "http_port" {
  description = "HTTP port used by the Apache web server"
  type        = number
}

variable "http_cidr" {
  description = "IPv4 CIDR allowed to access Apache over HTTP"
  type        = string
}

variable "http_nacl_rule_number" {
  description = "Rule number for the HTTP Network ACL rule"
  type        = number
}