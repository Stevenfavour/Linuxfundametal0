# Linux Fundamentals

Starting with an already created Ubuntu based EC2 Instance on AWS below shows the steps take to carry out this project.

## 1. Linux-3mtt Instance
Below is the image of the provisioned EC2 instance (server).
![Linux based EC2 instance](./Img/A.png)

## 2. Instance Details
Details of the instance are shown in the image below, displating the Instance ID, Private and Publi DNS addresses and IP addresses as well as the newly created SSH keypair.
![Linux based EC2 instance](./Img/B.png)

## 3. Client Tool

Client tool that will be used in creating the connection with the remote server from the local environment is GitBash. Having also located the directory of the downloaded public keypair
![Linux based EC2 instance](./Img/C.png)

## 4. Creating the connection with SSH

Below show the command for creating the connection using ssh -l command and successfully connected to linux-3mtt instance. The image also show the details of the remote server including memory usage percentage and IP addresses. 
![Linux based EC2 instance](./Img/D2.png)

## 5. Package Manager

Refreshing the package list using the "sudo apt update" command 

![Linux based EC2 instance](./Img/E.png)

## 6. Package Manager

Installing the tree package. 

![Linux based EC2 instance](./Img/F.png)

Removing the tree package and verifying 

![Linux based EC2 instance](./Img/G.png)

![Linux based EC2 instance](./Img/H.png)