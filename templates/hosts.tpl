%{ for index, l in lbs ~}
${lower(l["name"])} ansible_ssh_host=${l["ipv4_addresses"][0]} ansible_become=yes ansible_become_password="${ansible_become_password}" keepalived_initial_state=${index == 0 ? "master" : "backup"} keepalived_priority=${index == 0 ? "100" : "50"}
%{ endfor ~}
%{ for m in masters ~}
${lower(m["name"])} ansible_ssh_host=${m["ipv4_addresses"][0]} ansible_become=yes ansible_become_password="${ansible_become_password}" kubelet_extra_args="--node-ip=${m["ipv4_addresses"][1]}"--node-labels=topology.rook.io/room=${m["room"]} apiserver_local_address=${m["ipv4_addresses"][1]} etcd_local_address=${m["ipv4_addresses"][1]} ansible_connection=ssh ansible_become_user=root
%{ endfor ~}
%{ for n in nodes ~}
${lower(n["name"])} ansible_ssh_host=${n["ipv4_addresses"][0]} ansible_become=yes ansible_become_password="${ansible_become_password}" kubelet_extra_args="--node-ip=${n["ipv4_addresses"][1]} --node-labels=topology.rook.io/room=${n["room"]}" ansible_connection=ssh ansible_become_user=root
%{ endfor ~}
%{ for w in win_nodes ~}
${lower(w["name"])} ansible_user=${ansible_win_user} ansible_password="${ansible_win_password}" ansible_connection=winrm ansible_winrm_transport=basic ansible_winrm_host=${w["ipv4_addresses"][0]} kubelet_extra_args="--node-ip=${w["ipv4_addresses"][1]}" ansible_winrm_server_cert_validation=ignore ansible_become=yes ansible_become_method=runas ansible_become_user=Administrator
%{ endfor ~}
%{ for index, g in gpu_nodes ~}
${lower(g["name"])} ansible_ssh_host=${g["ipv4_addresses"][0]} ansible_become=yes ansible_become_password="${ansible_become_password}" kubelet_extra_args="--node-ip=${g["ipv4_addresses"][1]} --node-labels=node.kubernetes.io/role=gpu --register-with-taints=dedicated=gpu:NoSchedule" cri_socket="/var/run/dockershim.sock" ansible_connection=ssh ansible_become_user=root

%{ endfor ~}

[master]
%{ for m in masters ~}
${lower(m["name"])}
%{ endfor ~}

[node]
%{ for n in nodes ~}
${lower(n["name"])}
%{ endfor ~}

[win_node]
%{ for w in win_nodes ~}
${lower(w["name"])}
%{ endfor ~}

[lb]
%{ for index, l in lbs ~}
${lower(l["name"])}
%{ endfor ~}

[node_local_vol]
%{ for n in nodes ~}
${n["local_volumes"] != [] ? lower(n["name"]) : ""}
%{ endfor ~}

[gpu_node]
%{ for index, g in gpu_nodes ~}
${lower(g["name"])}
%{ endfor ~}
