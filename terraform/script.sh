#!/bin/bash

# Install Docker on Ubuntu
install_docker_ubuntu() {
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Install Docker on Ubuntu
install_docker_ubuntu

sudo systemctl start docker
sudo systemctl enable docker

sudo docker pull aymogul/java-task:latest

sudo docker run -d -p 80:8080 aymogul/java-task:latest

