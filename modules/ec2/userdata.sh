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

# Install Java (required for Jenkins)
sudo apt install -y openjdk-11-jre

# Add Jenkins repository and install Jenkins
wget -q -O - https://pkg.jenkins.io/jenkins.io.key | sudo apt-key add -
echo deb http://pkg.jenkins.io/debian/ stable main | sudo tee -a /etc/apt/sources.list.d/jenkins.list
sudo apt update -y
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins  # Check Jenkins status

# Open the Jenkins port (8080) - make sure your firewall/security group allows it
sudo ufw allow 8080

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

# Ensure SSH config is set to disable strict host checking
echo "Host *" > /home/ubuntu/.ssh/config
echo "    StrictHostKeyChecking no" >> /home/ubuntu/.ssh/config
echo "    UserKnownHostsFile /dev/null" >> /home/ubuntu/.ssh/config
chmod 600 /home/ubuntu/.ssh/config
chown ubuntu:ubuntu /home/ubuntu/.ssh/config

# Display Ansible version
echo "Ansible version:"
ansible --version
