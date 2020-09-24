resource "vsphere_drs_vm_override" "drs_vm_override_masters" {
  count              = length(var.masters)
  compute_cluster_id = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_id = vsphere_virtual_machine.masters[count.index].id
  drs_enabled        = false
}

resource "vsphere_drs_vm_override" "drs_vm_override_nodes" {
  count              = length(var.nodes)
  compute_cluster_id = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_id = vsphere_virtual_machine.nodes[count.index].id
  drs_enabled        = false
}

resource "vsphere_drs_vm_override" "drs_vm_override_lbs" {
  count              = length(var.lbs)
  compute_cluster_id = data.vsphere_compute_cluster.compute_cluster.id
  virtual_machine_id = vsphere_virtual_machine.lbs[count.index].id
  drs_enabled        = false
}
