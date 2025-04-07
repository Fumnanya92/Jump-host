[defaults]
inventory = inventory.ini
remote_user = ubuntu
private_key_file = ~/.ssh/my_terraform_key.pem
host_key_checking = False
retry_files_enabled = False
interpreter_python = /usr/bin/python3

[ssh_connection]
ssh_args = -o ProxyCommand="ssh -i ~/.ssh/my_terraform_key.pem -W %h:%p ubuntu@${bastion_ip}"

