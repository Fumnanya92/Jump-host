import json
import subprocess

# Load Terraform output using 'terraform output' command
def load_terraform_output(output_name):
    result = subprocess.run(['terraform', 'output', '-json', output_name], capture_output=True, text=True)
    return json.loads(result.stdout)[output_name]['value']

# Generate inventory file for Bastion and Nginx servers
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
    # Define private key path and inventory file path
    private_key_path = '~/.ssh/my_terraform_key.pem'
    inventory_file_path = './ansible/inventory.ini'
    
    # Load Bastion and Nginx IPs using Terraform outputs
    bastion_ip = load_terraform_output("bastion_ip")
    nginx_ips = load_terraform_output("nginx_servers")
    
    # Generate inventory content
    inventory_content = generate_inventory(bastion_ip, nginx_ips, private_key_path)
    
    # Write the content to the inventory file
    with open(inventory_file_path, 'w') as f:
        f.write(inventory_content)

if __name__ == "__main__":
    main()
