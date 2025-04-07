[bastion]
${bastion_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my_terraform_key.pem

[nginx_servers]
${private_ips}

[nginx_servers:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/my_terraform_key.pem -W %h:%p ubuntu@${bastion_ip}"'
ansible_ssh_private_key_file=~/.ssh/my_terraform_key.pem

[all:vars]
ansible_python_interpreter=/usr/bin/python3
