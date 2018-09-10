
Creating a Private Ethereum Network and Adding Nodes/Miners to That Network. 

What is a Private Ethereum Network? 

What is Ethereum? 
From the the Ethereum Project:
"Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed 
without any possibility of downtime, censorship, fraud or third-party interference.

These apps run on a custom built blockchain, an enormously powerful shared global infrastructure that can 
move value around and represent the ownership of property."
https://www.ethereum.org/

...

Private Network vs. Public Network
https://github.com/ethereum/go-ethereum/wiki/Private-network
Inroduce consortium definition here. 

Creating a Private Network 
https://ethereum.stackexchange.com/questions/13547/how-to-set-up-a-private-network-and-connect-peers-in-geth
https://github.com/ethereum/go-ethereum/wiki/Setting-up-private-network-or-local-cluster

Geth stands for Go Ethereum. It is a full Ethereum node implemented in the Go programming language. 
https://github.com/ethereum/go-ethereum/wiki/geth


The Genesis Block for your private network
All nodes on the same network need to be initialized to the same genesis state. 
This means they need to use the same genesis file to initialize the node commonly called genesis.json. 

Adding a node/miner to the Private Network

First create a directory that will hold all the data for your chain. Typically this directory is call chaindata and all examples will use this term. 
Before you create your node for the first time. 
Create an account that will accept the mining rewards. This needs to be run in the same directory as chaindata 
exists. 
geth account new --datadir chaindata

This command will give you an account/address and create a private key file for it in chaindata/keystore. 
You will need this account when your nodes starts to mine. 

Now you can initialize your node to point to the private nework with the same genesis block using genesis.json
For testing purposes, you can allocate ether to your account to test with in the genensis.json alloc section. Its recommended
you do this before initialization. 
geth --datadir chaindata init genesis.json

Before Starting Your Node for the First Time
When you start the node you will need to unlock the account before it can be used. 
Create a password file with the password you used to create the account. The path to this file will be specified 
when you start the node. Its recommended to put the file in chaindata/password. 

Starting Your Node For the First Time 
Run this is the same directory where chaindata exists.
geth --datadir chaindata --networkid 63 --identity "node1" --etherbase=0x348cdfd4875cd7c522e1ea0376b07b03e850b02a --rpc --rpcport 8885 --rpccorsdomain “*” --rpcaddr "0.0.0.0" --rpcapi db,eth,net,web3,personal,miner --ws --wsorigins="*" --wsapi db,eth,net,web3,personal --port 30303 --nodiscover --maxpeers 10 --verbosity 3 --unlock 0  --password chaindata/password.txt --mine --minerthreads=5 

--datadir chaindata : data directory for your chain. Same directory used creating the accounts  
--networkid 63 : This is important and MUST match the chainID from the genesis file. It specifies which network you are connecting to. 1 is the public network. 
--identity "node1" : this parameter simply provides a name for the running node. You can name it anything
--etherbase <address> :  This specifie the address to put the ethere you get for mining. 

--rpc : rpc is a remote procedure call. This parameter tells geth to create an http endpoint used to call the ethereum applications
--rpcapi db,eth,net,web3,personal,miner : these are APIs you can start to interact with the geth node  
--rpcport 8885 : port for the rpc APIs
--rpccorsdomain “*” : security for the APIs. * means anyone can call these APIs. Not recommended outside of demo. 
--rpcaddr "0.0.0.0" : setting for allowing remote connections used with rpccorsdomain 

--ws : Similar to rpc, this opens up connections for web sockets.  
--wsorigins="*" : similar to cors domains above. * allows any web socket origin. 
--wsapi db,eth,net,web3,personal : APIs exposed over the websockets. 

--port 30303 : port used for ethereum network communication to talk with other nodes.  
--nodiscover : when set does not allow other nodes to automatically find you. Ohter nodes will need to add you as a peer explicitly.   
--maxpeers 10 : maximum number of nodes that can connect as a peer to this node
--verbosity 3 : logging 
--unlock 0 : When the node starts up it creates an array of accounts (that are in chaindata/keystore). This parameter says unlock accounts at position 0 in the array. This can be a comma separated list. 
--password chaindata/password.txt : file with the passwords used to unlock you accounts.
--mine : tells this node to mine
--minerthreads=5 : number of CPU threads used to mine

Using the Geth Console to Interact with the Node
geth attach http://127.0.0.1:8885

Adding a peer
admin.addPeer("enode://3108e07c9d539443b281c66a6d731372b4f7c793c5705cc759f43d9297a241978ee7bcf86dfae89621e969807d8219eb7964e39bb972f10c8baf3df5fd60c0b5@18.212.195.193:30303?discport=0")


Boot Node Information
IP Address: 18.212.195.193
Endoe info:
enode://3108e07c9d539443b281c66a6d731372b4f7c793c5705cc759f43d9297a241978ee7bcf86dfae89621e969807d8219eb7964e39bb972f10c8baf3df5fd60c0b5@18.212.195.193:30303?discport=0
start the 

