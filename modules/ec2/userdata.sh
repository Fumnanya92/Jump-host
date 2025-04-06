#!/bin/bash
set -e

# Update and install dependencies
echo "Updating and installing essentials..."
apt-get update -y
apt-get upgrade -y
apt-get install -y python3 python3-pip git unzip curl software-properties-common

# Install Ansible (latest)
pip3 install --upgrade pip
pip3 install ansible

# Setup directory for Ansible
mkdir -p /home/ubuntu/ansible

# Setup private SSH key
mkdir -p /home/ubuntu/.ssh
if [ -n "${private_key}" ]; then
    echo "${private_key}" | base64 --decode > /home/ubuntu/.ssh/id_rsa
    chmod 400 /home/ubuntu/.ssh/id_rsa
    chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
else
    echo "Private key not provided."
fi

echo "Ansible version:"
ansible --version
