# Output the Security Group ID
output "security_group_id" {
  value = aws_security_group.sg.id
}