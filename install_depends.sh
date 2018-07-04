#!/bin/bash

sudo apt update && sudo apt upgrade -y && sudo apt autoremove
sudo apt install -y ssh openssh-server pdsh openjdk-8-jdk

