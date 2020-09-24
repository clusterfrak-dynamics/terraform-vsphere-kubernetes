locals {
  masters_defaults_defaults = {}
  masters                   = [for m in var.masters : merge(local.masters_defaults_defaults, var.masters_defaults, m)]
}

resource "vsphere_virtual_machine" "masters" {
  count            = length(local.masters)
  name             = local.masters[count.index]["name"]
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  folder           = var.vsphere_data["folder"]
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = local.masters[count.index]["room"] == "room_i" ? data.vsphere_host.hosts_room_i[count.index % length(data.vsphere_host.hosts_room_i)].id : local.masters[count.index]["room"] == "room_c" ? data.vsphere_host.hosts_room_c[count.index % length(data.vsphere_host.hosts_room_c)].id : null

  num_cpus = local.masters[count.index]["num_cpus"]
  memory   = local.masters[count.index]["memory"]

  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  dynamic "network_interface" {
    for_each = vsphere_distributed_port_group.pg
    iterator = pg
    content {
      network_id   = pg.value["id"]
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = lower(local.masters[count.index]["name"])
        domain    = local.masters[count.index]["domain"]
        time_zone = local.masters[count.index]["timezone"]
      }
      dynamic "network_interface" {
        for_each = local.masters[count.index]["ipv4_addresses"]
        iterator = ip
        content {
          ipv4_address = ip.value
          ipv4_netmask = local.masters[count.index]["ipv4_netmask"]
        }
      }

      ipv4_gateway    = local.masters[count.index]["ipv4_gateway"]
      dns_server_list = local.masters[count.index]["dns_server_list"]
      dns_suffix_list = local.masters[count.index]["dns_suffix_list"]
    }
  }

  lifecycle {
    ignore_changes = [
      storage_policy_id,
      disk[0].storage_policy_id,
      disk[1].storage_policy_id,
      disk[2].storage_policy_id,
      disk[3].storage_policy_id,
      disk[4].storage_policy_id,
      disk[5].storage_policy_id,
      disk[6].storage_policy_id,
      disk[7].storage_policy_id,
      disk[8].storage_policy_id,
      disk[9].storage_policy_id,
      custom_attributes,
      tags
    ]
  }
}
