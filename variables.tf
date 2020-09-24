variable vsphere_user {}

variable vsphere_password {}

variable vsphere_server {}

variable vsphere_data {
  type = any
}

variable windows_data {
  type = any
}

variable linux_data {
  type = any
}

variable vsphere_networks {
  type = any
}

variable lbs_defaults {
  type    = any
  default = {}
}

variable lbs {
  type    = any
  default = {}
}

variable masters_defaults {
  type    = any
  default = {}
}

variable masters {
  type    = any
  default = []
}

variable nodes_defaults {
  type    = any
  default = {}
}

variable win_nodes_defaults {
  type    = any
  default = {}
}

variable nodes {
  type    = any
  default = {}
}

variable win_nodes {
  type    = any
  default = {}
}

variable gpu_nodes {
  type    = any
  default = {}
}

variable write_ansible_inventory {
  type    = bool
  default = false
}

variable ansible_inventory_path {
  default = "./hosts"
}
