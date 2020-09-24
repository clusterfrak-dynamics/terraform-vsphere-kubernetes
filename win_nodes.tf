locals {
  win_nodes_defaults_defaults = {}
  win_nodes                   = [for m in var.win_nodes : merge(local.win_nodes_defaults_defaults, var.win_nodes_defaults, m)]
}

resource "vsphere_virtual_machine" "win_nodes" {
  count            = length(local.win_nodes)
  name             = local.win_nodes[count.index]["name"]
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  folder           = var.vsphere_data["folder"]
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = local.win_nodes[count.index]["room"] == "room_i" ? data.vsphere_host.hosts_room_i[count.index % length(data.vsphere_host.hosts_room_i)].id : local.win_nodes[count.index]["room"] == "room_c" ? data.vsphere_host.hosts_room_c[count.index % length(data.vsphere_host.hosts_room_c)].id : null

  firmware          = "efi"
  nested_hv_enabled = true

  num_cpus = local.win_nodes[count.index]["num_cpus"]
  memory   = local.win_nodes[count.index]["memory"]

  guest_id = data.vsphere_virtual_machine.win_template.guest_id

  scsi_type = data.vsphere_virtual_machine.win_template.scsi_type

  dynamic "network_interface" {
    for_each = vsphere_distributed_port_group.pg
    iterator = pg
    content {
      network_id   = pg.value["id"]
      adapter_type = data.vsphere_virtual_machine.win_template.network_interface_types[0]
    }
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.win_template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.win_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.win_template.disks.0.thin_provisioned
  }

  dynamic "disk" {
    for_each = local.win_nodes[count.index]["local_volumes"]
    iterator = pv
    content {
      label            = pv.value["label"]
      size             = pv.value["size"]
      eagerly_scrub    = pv.value["eagerly_scrub"]
      thin_provisioned = pv.value["thin_provisioned"]
      unit_number      = pv.value["unit_number"]
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.win_template.id

    customize {
      windows_options {
        computer_name  = lower(local.win_nodes[count.index]["name"])
        workgroup      = local.win_nodes[count.index]["workgroup"]
        admin_password = var.windows_data["password"]
        time_zone      = local.win_nodes[count.index]["timezone"]
        full_name      = var.windows_data["username"]
      }
      dynamic "network_interface" {
        for_each = local.win_nodes[count.index]["ipv4_addresses"]
        iterator = ip
        content {
          ipv4_address    = ip.value
          ipv4_netmask    = local.win_nodes[count.index]["ipv4_netmask"]
          dns_server_list = local.win_nodes[count.index]["dns_server_list"]
          dns_domain      = local.win_nodes[count.index]["dns_domain"]
        }
      }

      ipv4_gateway = local.win_nodes[count.index]["ipv4_gateway"]
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
      host_system_id,
      custom_attributes,
      tags
    ]
  }
}
