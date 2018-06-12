#!/bin/bash
# Compatible with MacOSX, Ubuntu, Fedora
# Checks system type, installs python and ansible
# Runs ansible playbook


is_mac_host() {
    arch=$(uname)
    if [ "$arch" == "Darwin" ]; then
        return true
    else
        return false
    fi
}


if [ is_mac_host ]; then
    echo "🐰 darwin"

    ansible-galaxy install -r requirements.yml
    ansible-playbook plays/mac-dev.yml
else

    # if currently root user, then don't need sudo
    # makes this script work in docker containers
    # where sudo isn't a valid command
    sudo=""
    if [[ $EUID -ne 0 ]]; then
        sudo="sudo"
    fi

    # ubuntu
    echo "🐭 ubuntu"
    $sudo apt update -y && $sudo apt install python-minimal python-pip -y
    pip install ansible

    ansible-galaxy install -r requirements.yml
    ansible-playbook plays/ubuntu-dev.yml
fi


