#!/bin/bash
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
sudo apt-get install tree
cd /etc/ansible
sudo ansible all -m ping

sudo cp -f ./hosts /etc/ansible/