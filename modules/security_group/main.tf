resource "aws_security_group" "sg" {
  for_each = var.security_groups

  name        = each.key
  description = each.value.description
  vpc_id      = each.value.vpc_id

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )
}

resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.ingress_rules : "${rule.sg_name}-${rule.idx}" => rule
  }

  type                     = "ingress"
  security_group_id        = aws_security_group.sg[each.value.sg_name].id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks        = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  self                     = each.value.self ? true : null
  source_security_group_id = each.value.source_security_group_id != null ? each.value.source_security_group_id : null
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in local.egress_rules : "${rule.sg_name}-${rule.idx}" => rule
  }

  type                     = "egress"
  security_group_id        = aws_security_group.sg[each.value.sg_name].id
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  ipv6_cidr_blocks        = length(each.value.ipv6_cidr_blocks) > 0 ? each.value.ipv6_cidr_blocks : null
  self                     = each.value.self ? true : null
  source_security_group_id = each.value.source_security_group_id != null ? each.value.source_security_group_id : null
}