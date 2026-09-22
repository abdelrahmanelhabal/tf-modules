output "security_group_ids" {
  description = "Map of created security group IDs keyed by security group name."
  value       = { for name, sg in aws_security_group.sg : name => sg.id }
}

output "security_group_names" {
  description = "Map of created security group names keyed by security group name."
  value       = { for name, sg in aws_security_group.sg : name => sg.name }
}
