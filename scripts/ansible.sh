#!/bin/bash

dnf -y install sudo

# Variables
USERNAME="ansible"
SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvEwDo1nDfKHtaQI+F+ZiM9e8LZkiWkPjLl/HMGunVA6EB6qOYP9NxGa29EoYhcC+HB1Q7+s/QjHpxLf0+Eu5HAQZuAcyDKUPYbXuQrbVphecLIJQqwUyFQEJ/9NBzAVthMl99WE/g3uPAx5GMqIKZ0nkH7/3SrBVyyt4m0FdipQuqiE64P0TFGzgkqWafFUUQs+bEc7HMDGhlK3fu6trurF4SXrzujSWHdCeeM4UThtjkuHf3H0W0wt1t6TsBPKDfWKu0lUpcv/et4YXU8V1z7PVvy3nW/05sZsuzViE8+Z/yw9mfVq0KAVY6MXY4gdhdft7g+j670WrtDlsBQXIIJoVjtjNM5N3HVTmqx7toYz9rtHVJLwR12JG7vFr/h2ztaY8Ek+3OlLARmaVvN5DhV/KoF/6kYKAgxcXTZR2WiJTlBOX0l+bjTxGybUzFgA4UOsuEleua/76OQqhe/b/GUPX4PJgsvzc1NlSLAkcCzwS4WDMZjxoEj13yJQ3ALWM= ansible@tmedia1.uscoutfor.local"

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
