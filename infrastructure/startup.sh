#!/bin/bash
sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install docker
sudo apt -y install docker.io

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose 

#Add user to docker group
sudo usermod -a -G docker ${USER}
newgrp docker

sudo usermod -a -G docker ubuntu
newgrp docker
gcloud auth configure-docker us.gcr.io --quiet
gcloud auth activate-service-account --key-file=/home/ubuntu/creds.json
rm /home/ubuntu/creds.json
sleep 120
exec bash
exit 0