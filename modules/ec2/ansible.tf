resource "local_file" "inventory" {
  content  = local.inventory_content
  filename = "${path.module}/ansible/inventory.ini"
}

resource "local_file" "ansible_cfg" {
  content  = templatefile("${path.module}/ansible/ansible_cfg.tpl", {
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
    user        = "ec2-user"
    private_key = tls_private_key.terraform.private_key_pem
  }

  # File provisioner to copy the Ansible files from your local machine to the EC2 instance
  provisioner "file" {
    source      = "${path.module}/ansible"
    destination = "/tmp/ansible"
  }

    provisioner "file" {
        content     = tls_private_key.terraform.private_key_pem
        destination = "/tmp/my_terraform_key.pem"
    }

  # Remote exec to run the Ansible playbook after all files are copied
   provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/.ssh",
      "echo 'Host *' >> ~/.ssh/config",
      "echo 'StrictHostKeyChecking no' >> ~/.ssh/config",
      "echo 'UserKnownHostsFile /dev/null' >> ~/.ssh/config",
      "chmod 600 ~/.ssh/config",
      "chown ec2-user:ec2-user ~/.ssh/config",
      "sudo mv /tmp/my_terraform_key.pem ~/.ssh/my_terraform_key.pem",
      "sudo chown ec2-user:ec2-user ~/.ssh/my_terraform_key.pem",
      "chmod 400 ~/.ssh/my_terraform_key.pem",
      "echo 'Installing Ansible if needed...'",
      "sudo yum install -y python3 python3-pip",
      "which ansible || { echo 'Installing Ansible...'; pip3 install --upgrade ansible; }",
      "ansible --version",
      "cd /tmp/ansible",
      "ansible-playbook -i inventory.ini playbook.yml"
    ]
  }

}

