#!/bin/bash
# user data for the jupyter notebook instances. download, installs and runs jupyter notebook container with no password
yum update -y
yum install docker -y
systemctl start docker
docker run --name unauthenticated-jupyter-notebook -p 8888:8888 -d jupyter/base-notebook start-notebook.sh --NotebookApp.token=''
