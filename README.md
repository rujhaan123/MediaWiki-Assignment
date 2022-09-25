# Assignment - MEDIAWIKI PROBLEM STATEMENT
Automating the Deployment of Mediawiki using Terraform for provisioning server with integration of Bash script for LAMP stack configuration.

## Overview
This automation has been done on GCP using CentOS as the image for hosting configuartion. Below are the tools used as prerequisites
- GIT
- Terraform
- GCPCLI
- GCP
- VSCode

## Screenshots and steps to run Automation

- Clone the repo using below command in your local machine

- Run the `terraform init` command 
- Run `terraform plan`
- Run `terraform apply`
- After terraform apply we can see infra provisioning will start

![image](https://user-images.githubusercontent.com/33410430/192149611-c4f10b1a-574c-47e1-b57c-58f25d91df25.png)
![image](https://user-images.githubusercontent.com/33410430/192149630-09e62747-b394-4a73-8a71-99ab3fe19ee1.png)
![image](https://user-images.githubusercontent.com/33410430/192149686-a491a5fa-0ac6-407a-a3af-8782f0a443e9.png)


- Once it has been completed we can verify the server status on VM instances under Compute Engine
