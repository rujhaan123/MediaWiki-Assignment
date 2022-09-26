# Assignment - MEDIAWIKI PROBLEM STATEMENT
Automating the Deployment of Mediawiki using Terraform for provisioning server with integration of Bash script for LAMP stack configuration.

## Overview
This automation has been done on GCP using CentOS as the image for hosting configuration. Below are the tools used as prerequisites
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

- Once it has been completed we can verify the server status on VM instances under Compute Engine

![image](https://user-images.githubusercontent.com/33410430/192149686-a491a5fa-0ac6-407a-a3af-8782f0a443e9.png)

- SSH into the server and verifying the script placed and executed by terraform provisioner.

![image](https://user-images.githubusercontent.com/33410430/192189226-5984fa35-f4d8-4c55-8481-4d22af141045.png)

- Running the mediawiki webpage. As per the screenshot below it shows internal error because of version is incompatible. It can be upgraded but as per the task kept the same instuctions which was given.

![image](https://user-images.githubusercontent.com/33410430/192189375-c421e6ac-820c-46b9-9769-06a87973b22d.png)




