#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install docker
sudo apt-get install -y docker-ce docker.io

# Install docker-compose
sudo apt -y install docker-compose

#Add user to docker group
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo apt-get update

# Install git
sudo apt-get install git -y