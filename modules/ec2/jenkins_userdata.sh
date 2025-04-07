#!/bin/bash
# Update packages
sudo apt update -y

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

# Open the Jenkins port (8080)
sudo ufw allow 8080
