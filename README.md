# Mine the Blockchain Challenge

In this challenge you are going to set up an Ethereum miner hosted on an Amazon EC2 linux server. 
You will also be able to interact with Smart Contracts deployed on the network to get a basic undersatnding for how they work.    

## Getting Started

### Ethereum
"[Etherum](https://www.ethereum.org/)  is a decentralized platform that runs smart contracts: applications that run exactly as programmed 
without any possibility of downtime, censorship, fraud or third-party interference.

These apps run on a custom built blockchain, an enormously powerful shared global infrastructure that can 
move value around and represent the ownership of property."

Ethereum Smart Contacts are applicaitons written in the Solidity programming language that run on an Ethereum network. The main purpose of the contracts is to control transactions and exchange of value between accounts on the network. The currency of echange on the network is called ether and it is the second most valued public cryptocurrency behind Bitcoin. 

The main Ethereum network is public and anyone with ether can deploy smart contracts to it. Miners are nodes in this decentralized network that execute smart contract code and verify all transactions on they make. The state of these transactions are stored in a Blockchain database and an exact copy of it is ditributed to all nodes in the network. A miner that is the first to verify a specific set of transactions, and all nodes agree on this verification, gets ether as a reward.

#### Private Miner
Your challenger is 
Ethereum is also a platform that can be used to establish a private network that has all of the functionality of the public side, but unlike the public side, an admisitrator governs who is allowed to run a node in the network. When business partners choose to participated in a decentralized private network, its called a consortium. 

I have created a private network and am hosting it on an AWS EC2 Medium instance running Amazon's Linux. As a demo I have created a rental app using web and conversational apps that interact with a smart contract deployed on the network. 

This challenge is to create a private ethereum mining node on an AWS EC2 instance.  

### Prerequisites
Running this challenge necessitates basic SSH software and understanding for executing commands from the command line. 

* Install an ssh client and know how to use it. You will need to remote log into a server running on AWS using a key file. Please consult documentation on how to use your SSH client.
    * Ex. Windows use Putty. 
    * Macs can use the command line.

## Challenge 1 - Creating an EC2 Instance to Host Your Miner

* Create an Amazon EC2 Instance. This will be used to host your miner. 
    * [Log into AWS console](https://nwblockchain.signin.aws.amazon.com/console)
    * *IMPORTANT* make sure the N. Virginia Zone is selected in the top right corner. 
    * Select "EC2" under the "Services Menu"
    * Select the "Running Instances" Link
    * Creating a new instance
        * Select the checkbox next to existing instance: "Blockchain Host"
        * Select the "Action" button and "Launch More Like This" 
        * Select "3. Configure Instance" from the links at the top. 
            * Scroll down and expand the "Advanced" section.
            * In the "User Data Box" Copy-and-Paste [the script found here.](https://github.com/mchizmar/learnathon/blob/master/setting-up-a-miner/installgeth.sh)
            * Leave the "As Text" button selected. 
            * Click the "Review and Launch" button at the bottom of the screen. 
        * Edit Tags to change the name 
            * Scroll to the "Tags" section and Expand it. 
            * Hit "Edit Tags" Link.
            * Edit and the "Name" value. Please use something like: <short-name>Instance. 
        * Select the "Launch" Button
        * Select Choose an existing key pair and nwblockchain-key
        * Acknowledge and "Launch Instance"
        * In the EC2 Dashboard *wait* till the "Instance State" column says "running"

## Challenge 2 - Creating a Miner
At this point, creating a miner is a relatively simple task, assuming the prerequisites have been followed. 

### Creating a Local Miner
* Open up a command line - DOS or MacOS/Bash shell. 
* Change directory to learnathon/setting-up-a-miner
* Initializing your miner to mine on my private network. 
    * This is done by running the geth command below. Recall, the genesis.json has to be the exact file used to create the intial node. If you use the file from github you should be fine: 
        * geth --datadir chaindata init genesis.json
* Now that you are configured and initialized, you can now being joining the network by starting up a geth node instance. 
    * Starting your geth node to connect to the my private network:
        * geth --datadir chaindata --networkid 63 --identity "node1" --etherbase=0x348cdfd4875cd7c522e1ea0376b07b03e850b02a --rpc --rpcport 8885 --rpccorsdomain “\*” --rpcaddr "0.0.0.0" --rpcapi db,eth,net,web3,personal,miner --ws --wsorigins="\*" --wsapi db,eth,net,web3,personal --port 30303 --nodiscover --maxpeers 10 --verbosity 3 --unlock 0  --password chaindata/password.txt --mine --minerthreads=5 


Dissecting the geth command. 

--datadir chaindata : data directory for your chain. Same directory used creating the accounts  
--networkid 63 : This is important and **MUST** match the chainID from the genesis file. It specifies which network you are connecting to. 1 is the public network. 
--identity "node1" : this parameter simply provides a name for the running node. You can name it anything
--etherbase address :  This specifie the address to put the ethere you get for mining. 

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




* Genesis File 
    * A genesis file is a configuration file describing the network you are joining or creating.
    * You are joining an existing network for this challenge which requires you to use the **exact** genesis file the original network was created from and is found in: 
        * from github learnathon/setting-up-a-miner/genesis.json
    * Verify with md5sum for genesis.json: 661aa786e2d52d64bfe31fc05ec666af

* Storing Chain Data
    * Chain data is the information created and stored when you are mining. Its the Blockain. 
    * It is recommended to use learnathon/setting-up-a-miner/chaindata. 
        * chaindata/keystore contains the keys for accounts have have been preconfigured on the network. 
        * You need these keys to create a miner on the network.
    * This chaindata is also known as "datadir" for the upcoming geth commands. 
