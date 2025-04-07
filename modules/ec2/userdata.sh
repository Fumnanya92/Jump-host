#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "Updating and installing essentials..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-pip git unzip curl software-properties-common wget apt-transport-https gpg

# Install Java (required for Jenkins)
sudo apt-get install -y fontconfig openjdk-17-jre

# Add Jenkins repository and install Jenkins
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo mkdir -p /usr/share/keyrings
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
  | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y jenkins

# Skip setup wizard and configure admin user
sudo mkdir -p /var/lib/jenkins/init.groovy.d

cat << 'EOF' | sudo tee /var/lib/jenkins/init.groovy.d/basic-security.groovy > /dev/null
#!groovy
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

instance.save()
EOF

# Set Jenkins to consider initial setup complete
sudo bash -c 'echo 2.0 > /var/lib/jenkins/jenkins.install.UpgradeWizard.state'
sudo bash -c 'echo 2.0 > /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion'

# Fix permissions
sudo chown -R jenkins:jenkins /var/lib/jenkins

# Start and enable Jenkins
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Open the Jenkins port (8080)
sudo ufw allow 8080 > /dev/null 2>&1 || true

# Setup directory for Ansible
sudo -u ubuntu mkdir -p /home/ubuntu/ansible

# Setup private SSH key
sudo -u ubuntu mkdir -p /home/ubuntu/.ssh
if [ -n "${private_key}" ]; then
  echo "${private_key}" | base64 --decode | sudo tee /home/ubuntu/.ssh/id_rsa > /dev/null
  sudo chmod 400 /home/ubuntu/.ssh/id_rsa
  sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
else
  echo "Private key not provided."
fi

# Disable SSH strict host key checking
echo "Host *" | sudo tee /home/ubuntu/.ssh/config > /dev/null
echo "    StrictHostKeyChecking no" | sudo tee -a /home/ubuntu/.ssh/config > /dev/null
echo "    UserKnownHostsFile /dev/null" | sudo tee -a /home/ubuntu/.ssh/config > /dev/null
sudo chmod 600 /home/ubuntu/.ssh/config
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/config

# Display Ansible version
echo "Ansible version:"
ansible --version || echo "Ansible not installed."
