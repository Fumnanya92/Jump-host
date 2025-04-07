resource "local_file" "inventory" {
  content  = local.inventory_content
  filename = "${path.module}/ansible/inventory.ini"
}

resource "local_file" "ansible_cfg" {
  content = templatefile("${path.module}/ansible/ansible_cfg.tpl", {
    bastion_ip = aws_instance.bastion.public_ip
  })
  filename = "${path.module}/ansible/ansible.cfg"
}

resource "null_resource" "run_ansible" {
  depends_on = [
    local_file.inventory,
    local_file.ansible_cfg,
    aws_instance.bastion,
    aws_instance.private_servers,
  ]

  connection {
    host        = aws_instance.bastion.public_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.terraform.private_key_pem
  }

  provisioner "file" {
    source      = "${path.module}/ansible"
    destination = "/tmp/ansible"
  }

  provisioner "file" {
    content     = tls_private_key.terraform.private_key_pem
    destination = "/tmp/my_terraform_key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      # SSH Config Setup
      "mkdir -p ~/.ssh",
      "echo 'Host *' > ~/.ssh/config",
      "echo '    StrictHostKeyChecking no' >> ~/.ssh/config",
      "echo '    UserKnownHostsFile /dev/null' >> ~/.ssh/config",
      "chmod 600 ~/.ssh/config",
      "chown ubuntu:ubuntu ~/.ssh/config",
      "mv -f /tmp/my_terraform_key.pem ~/.ssh/my_terraform_key.pem",
      "chmod 400 ~/.ssh/my_terraform_key.pem",
      "echo 'Installing Ansible if not already present...'",
      "sudo DEBIAN_FRONTEND=noninteractive apt update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo DEBIAN_FRONTEND=noninteractive apt install -y ansible",
      "cd /tmp/ansible",
      "ansible-playbook -i inventory.ini playbook.yml"
    ]
  }
}
