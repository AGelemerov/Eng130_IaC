#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y
sudo apt-get install tree
cd /etc/ansible
sudo cp -f /home/ubuntu/host/hosts /etc/ansible/
sudo ansible all -m ping
