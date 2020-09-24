data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_data["datacenter"]
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_data["cluster"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "hosts_room_i" {
  count         = length(var.vsphere_data["hosts_room_i"])
  name          = var.vsphere_data["hosts_room_i"][count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "hosts_room_c" {
  count         = length(var.vsphere_data["hosts_room_c"])
  name          = var.vsphere_data["hosts_room_c"][count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.vsphere_data["dvs"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_data["datastore"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_data["template"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "win_template" {
  name          = var.vsphere_data["win_template"]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
