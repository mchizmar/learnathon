#!/bin/bash 

# Install prerequisite software - no sudo necessary b/c install scripts run as root
yes |  yum install golang
yes |  yum install gmp-devel
yes |  yum install git

#Create directories to do the the work
mkdir /home/ec2-user/ethereum

#Checkout the git repo
cd /home/ec2-user/ethereum/
git clone https://github.com/mchizmar/learnathon.git
          
# Build geth from source 
cd /home/ec2-user/ethereum 
wget https://github.com/ethereum/go-ethereum/archive/master.zip
unzip master.zip 
cd go-ethereum-master/
make geth

# Since the script is run as root, set the permissions
chown -R ec2-user:ec2-user  /home/ec2-user

# Set geth in the PATH
echo PATH=$PATH:/home/ec2-user/ethereum/go-ethereum-master/build/bin >> /home/ec2-user/.bash_profile
echo export PATH >> /home/ec2-user/.bash_profile
