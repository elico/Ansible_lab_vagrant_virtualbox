#!/usr/bin/env bash

# THIS SCRIPT WILL CREATE SSH KEYPAIR AND DISTRIBUTE ACROSS ALL NODES

ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""

# LOOPING THROUGH AND DISTRIBUTING THE KEY

for val in controller managed1 managed2; do 
	echo "-------------------- COPYING KEY TO ${val^^} NODE ------------------------------"
	sshpass -p 'vagrant' ssh-copy-id -o "StrictHostKeyChecking=no" vagrant@$val 
done

# CREATE THE INVENTORY FILE

PROJECT_DIRECTORY="/home/vagrant/ansible_project/"

mkdir -p $PROJECT_DIRECTORY
cd $PROJECT_DIRECTORY

# Creating the inventory file for all 3 nodes to run some adhoc command.

cat <<EOF >inventory
controller

[ubuntu1]
managed1

[ubuntu2]
managed2
EOF

cat <<EOF  > ansible.cfg
[defaults]
inventory = inventory
EOF

echo "-------------------- RUNNING ANSBILE ADHOC COMMAND - UPTIME ------------------------------"
echo


# running adhoc command to see if everything is fine

ansible all -i inventory -m "shell" -a "uptime"
echo