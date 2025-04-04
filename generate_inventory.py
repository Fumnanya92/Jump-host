import json

# Load Terraform output
def load_terraform_output(file_path):
    with open(file_path) as f:
        return json.load(f)

# Generate inventory file for bastion and nginx servers
def generate_inventory(bastion_ip, nginx_ips, private_key_path):
    inventory_content = []
    
    # Write Bastion Host entry
    inventory_content.append(f"[bastion]")
    inventory_content.append(f"{bastion_ip} ansible_user=ec2-user ansible_ssh_private_key_file={private_key_path}\n")
    
    # Write Nginx Servers entry
    inventory_content.append("[nginx_servers]")
    for ip in nginx_ips:
        inventory_content.append(f"{ip} ansible_user=ec2-user")
    
    # Write Nginx Variables (proxy through Bastion Host)
    inventory_content.append("\n[nginx_servers:vars]")
    inventory_content.append(f"ansible_ssh_common_args='-o ProxyCommand=\"ssh -i {private_key_path} -W %h:%p ec2-user@{bastion_ip}\"'")
    inventory_content.append(f"ansible_ssh_private_key_file={private_key_path}")
    
    return "\n".join(inventory_content)

# Main function to generate the inventory file
def main():
    terraform_output_file = 'terraform_output.json'
    private_key_path = '~/.ssh/my_terraform_key.pem'
    inventory_file_path = './ansible/inventory.ini'
    
    # Load output from terraform
    data = load_terraform_output(terraform_output_file)
    
    # Extract Bastion and Nginx IPs
    bastion_ip = data["bastion_ip"]["value"]
    nginx_ips = data["nginx_servers"]["value"]
    
    # Generate inventory content
    inventory_content = generate_inventory(bastion_ip, nginx_ips, private_key_path)
    
    # Write the content to the inventory file
    with open(inventory_file_path, 'w') as f:
        f.write(inventory_content)

if __name__ == "__main__":
    main()
