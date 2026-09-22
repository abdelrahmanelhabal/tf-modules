variable "security_groups" {
  description = "Map of security groups to create. Each entry defines the group metadata and its ingress/egress rules."
  type = map(object({
    description = string
    vpc_id      = string
    ingress = list(object({
      description              = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks              = optional(list(string), [])
      ipv6_cidr_blocks        = optional(list(string), [])
      self                     = optional(bool, false)
      source_security_group_id = optional(string, null)
    }))
    egress = list(object({
      description              = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks              = optional(list(string), [])
      ipv6_cidr_blocks        = optional(list(string), [])
      self                     = optional(bool, false)
      source_security_group_id = optional(string, null)
    }))
  }))
}

variable "tags" {
  description = "Common tags applied to all security groups."
  type        = map(string)
  default     = {}
}
