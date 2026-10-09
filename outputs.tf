output "legacy_server_public_ip" {
  description = "Elastic public IPv4 address of the Ubuntu legacy migration server"
  value       = aws_eip.legacy_server_eip.public_ip
}