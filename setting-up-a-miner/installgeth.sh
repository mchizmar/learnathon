

# Install prerequisite software 
yes | sudo yum install golang
yes | sudo yum install gmp-devel
yes | sudo yum install git

#Create directories to do the the work
mkdir ~/ethereum
mkdir ~/ethereum/learnathon

#Checkout the git repo
cd ~/ethereum/learnathon
git clone https://github.nwie.net/chizmm1/learnathon.git


# Build geth from source 
cd ~/ethereum 
wget https://github.com/ethereum/go-ethereum/archive/master.zip
unzip master.zip 
cd go-ethereum-master/
make geth
