resource "local_file" "ansible_k8s_inventory" {
  count           = var.write_ansible_inventory ? 1 : 0
  content         = templatefile("templates/hosts.tpl", { masters = local.masters, nodes = local.nodes, win_nodes = local.win_nodes, lbs = local.lbs, gpu_nodes = var.gpu_nodes, ansible_win_user = var.windows_data["username"], ansible_win_password = var.windows_data["password"], ansible_become_password = var.linux_data["become_password"] })
  filename        = var.ansible_inventory_path
  file_permission = 0644
}

output "ansible_k8s_inventory" {
  value = templatefile("templates/hosts.tpl", { masters = local.masters, nodes = local.nodes, win_nodes = local.win_nodes, lbs = local.lbs, gpu_nodes = var.gpu_nodes, ansible_win_user = var.windows_data["username"], ansible_win_password = var.windows_data["password"], ansible_become_password = var.linux_data["become_password"]})
}
