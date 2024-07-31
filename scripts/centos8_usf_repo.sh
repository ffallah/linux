#!/bin/bash

sudo rm -f /etc/yum.repos.d/*
sudo curl -o /etc/yum.repos.d/CentOS-Stream-USF.repo https://raw.githubusercontent.com/ffallah/linux/main/scripts/files/CentOS-Stream-USF.repo
