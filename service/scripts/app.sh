#!/bin/bash
yum install -y docker git telnet
systemctl enable docker
systemctl start docker
gpasswd -a ec2-user docker
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
docker pull nginx:1.15-alpine
docker run -d -p 80:80 --name web nginx:1.15-alpine
