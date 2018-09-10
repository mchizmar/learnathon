
# Install Go Language which Geth is implented in 
sudo yum install golang
sudo yum install gmp-devel

mkdir ethereum
cd ethereum 

# Get the Geth source code to build 
wget https://github.com/ethereum/go-ethereum/archive/master.zip
unzip master.zip 
cd go-ethereum-master/
make geth
