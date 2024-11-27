#!/bin/bash

dnf -y install sudo

# Variables
USERNAME="ansible"
SSH_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3giWbUEZPCo2+zLOujech/huG/Q49lw64rPlmYcvX0 ansible@grafana.usf.sport"

# Create the ansible user
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    sudo useradd -m -s /bin/bash "$USERNAME"
    echo "User $USERNAME created."
fi

# Create .ssh directory and set correct permissions
sudo mkdir -p /home/$USERNAME/.ssh
sudo chmod 700 /home/$USERNAME/.ssh

# Add the SSH key to authorized_keys
echo "$SSH_KEY" | sudo tee /home/$USERNAME/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/$USERNAME/.ssh/authorized_keys
sudo chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "SSH key added for $USERNAME."

# Grant sudo privileges
if ! sudo grep -q "^$USERNAME ALL=(ALL) NOPASSWD:ALL$" /etc/sudoers; then
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
    echo "Sudo privileges granted to $USERNAME."
else
    echo "$USERNAME already has sudo privileges."
fi

echo "Script execution completed."
