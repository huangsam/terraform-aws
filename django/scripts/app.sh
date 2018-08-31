#!/bin/bash
yum install -y docker git telnet
systemctl enable docker
systemctl start docker
gpasswd -a ec2-user docker
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64 -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
docker pull python:3.6.6
