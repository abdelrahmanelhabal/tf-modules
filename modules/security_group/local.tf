locals {
  ingress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for idx, rule in sg.ingress : merge(rule, {
        sg_name = sg_name
        idx     = idx
      })
    ]
  ])

  egress_rules = flatten([
    for sg_name, sg in var.security_groups : [
      for idx, rule in sg.egress : merge(rule, {
        sg_name = sg_name
        idx     = idx
      })
    ]
  ])
}
