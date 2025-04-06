#!/bin/bash
set -e

# Update package lists and upgrade packages
echo "Updating package lists..."
sudo yum update -y
sudo yum install python3 -y

# Install Git and unzip
echo "Installing Git and unzip..."
sudo yum install -y git unzip

# Create the ansible directory for later usage
echo "Creating Ansible directory..."
mkdir -p /home/ec2-user/ansible

# # Install Ansible
# echo "Installing Ansible..."
# sudo yum install ansible -y

# Ensure SSH key is available for accessing the private EC2 instances
mkdir -p ~/.ssh
if [ -z "${private_key}" ]; then
    echo "SSH key not present, skipping key setup."
else
    echo "${private_key}" | base64 --decode > ~/.ssh/id_rsa
    chmod 400 ~/.ssh/id_rsa
fi

# Check installed versions
echo "Installation complete: Terraform, Git, and Ansible are now installed."
echo "Ansible version:"
ansible --version
echo "Git version:"
git --version
echo "All installations are complete."
