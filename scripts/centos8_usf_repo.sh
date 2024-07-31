#!/bin/bash

sudo rm -f /etc/yum.repos.d/*
sudo curl -o /etc/yum.repos.d/CentOS-Stream-USF.repo https://github.com/ffallah/linux/raw/main/scripts/files/CentOS-Stream-USF.repo
