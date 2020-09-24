resource "vsphere_distributed_port_group" "pg" {
  count                           = length(var.vsphere_networks)
  name                            = var.vsphere_networks[count.index]["name"]
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
  vlan_id                         = var.vsphere_networks[count.index]["vlan_id"]
  allow_promiscuous               = true
  allow_forged_transmits          = true
}
