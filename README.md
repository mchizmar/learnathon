# Mining a Blockchain Challenge, Part 1

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
Ethereum is also a platform that can be used to establish a private network that has all of the functionality of the public side, but unlike the public network, an admisitrator governs who is allowed to run a node in the network. When business partners choose to participated in a decentralized private network, its called a consortium. 

I have created a private network and am hosting it on an AWS EC2 Medium instance running Amazon's Linux. As a demo my partner in crime Coty Collins and I have created a web and a conversational app that interacts with smart contracts deployed on the private network. The smart contracts programmatically manage the rental of an asset and the exchange in payment for that rental.

Miners are responsible for executing the smart contract code and validating any changes made to the contract. This challenge is to create a private ethereum mining node on an AWS EC2 instance.  

### Prerequisites
Running this challenge necessitates basic SSH software and understanding for executing commands from the command line. 

* Access to the guest network that will be used to secure login (ssh) to servers you will create on AWS. 

* Install an ssh client and know how to use it. You will need to remote log into a server running on AWS using a key file. Please consult documentation on how to use your SSH client.
    * Ex. Windows use Putty which is TSB approved. [AWS Instructions to use Putty.](https://docs.aws.amazon.com/console/ec2/instances/connect/putty)
    * Macs can use the command line.

## Challenge 1 - Creating an EC2 Instance to Host Your Miner

* Create an Amazon EC2 Instance. This will be used to host your miner. 
    * [Log into AWS console](https://nwblockchain.signin.aws.amazon.com/console)
    * **IMPORTANT** make sure the N. Virginia Zone is selected in the top right corner. 
    * Select "EC2" under the "Services Menu"
    * Select the "Running Instances" Link
    * Creating a new instance
        * Select the checkbox next to existing instance: "Blockchain Host"
        * Select the "Action" button and "Launch More Like This" 
        * Select "3. Configure Instance" from the links at the top. 
            * Scroll down and expand the "Advanced" section.
            * In the "User Data Box" there will be a script. **Replace** that script with [the script found here](https://github.com/mchizmar/learnathon/blob/master/setting-up-a-miner/installgeth.sh). 
            * Leave the "As Text" button selected. 
            * Click the "Review and Launch" button at the bottom of the screen. 
        * Edit Tags to change the name 
            * Scroll to the "Tags" section and Expand it. 
            * Hit "Edit Tags" Link.
            * Edit and the "Name" value. Please use something like: your-short-name-Instance. 
        * Select the "Launch" Button
        * Select Choose an existing key pair and nwblockchain-key
        * Acknowledge and "Launch Instance"
        * In the EC2 Dashboard *wait* till the "Instance State" column says "running" (about 5 min).
    * SSH into your instance
        * You will need the IPv4 address of your instance. 
            * In the EC2 Dashboard select your instance. 
            * IPv4 is found on the bottom of the page in the Description tab
        * You will need the key file
            * The key file [is found here.](https://github.com/mchizmar/learnathon/blob/master/setting-up-a-miner/nwblockchain-key.pem)
            * Copy-and-Paste the contents into a local file named "nwblockchain-key.pem".
                * Alternately you can clone this git repo. 
            * The username is **ec2-user** 
            * You can now ssh into the instance, Ex. :
                * ssh -i nwblockchain-key.pem ec2-user@ipv4
                * [AWS Instructions to use Putty](https://docs.aws.amazon.com/console/ec2/instances/connect/putty)

## Challenge 2 - Creating a Miner

At this point your server instance is up and running and you are logged into an SSH session. In order to c
* Initializing the Directory Structure. 
    * First you will need to create a directory that will store all of your miners data. We will call this directory chaindata. Lets create it.
    * A defualt "chaindata" is provided from the "ethereum/learnathon" directory and we will use that. 
    * Run these commands:
        * cd ethereum
        * cp -rf learnathon/setting-up-a-miner/chaindata .
    * chaindata contains important keystore and password information needed to create our miner and is used in the following commands. 

* Initializing the Miner
    * A miner is initialized using a genesis block config that describes the network your miner is connecting to. We will call it genesis.json.
    * All miners **have to use the exact same** genesis.json to connect to the network. It cannot even a blank space off.
    * A default genesis.json is provided. Copy it to the ethereum directory: 
        * cp learnathon/setting-up-a-miner/genesis.json .
    * Validate the genesis.json is an exact copy.
        * md5sum genesis.json
        * output has to be: 661aa786e2d52d64bfe31fc05ec666af
    * Now lets use the genesis file to initialize your miner. Run this command:
        * geth --datadir chaindata init genesis.json
    
* Running Your Miner 
    * Your chain is now initialized and you can now run the miner. 
    * In the ethereum directory, execute the following command (see details about command below): 
        * geth --datadir chaindata --networkid 63 --identity "node1" --etherbase=0x30855962411de128042b5d5c495c5c67a3b6498a --rpc --rpcport 8885 --rpccorsdomain “*” --rpcaddr "0.0.0.0" --rpcapi db,eth,net,web3,personal,miner --ws --wsorigins="*" --wsapi db,eth,net,web3,personal --port 30303 --nodiscover --maxpeers 10 --verbosity 3 --unlock 0 --password chaindata/password.txt --mine --minerthreads=5 
    * This outputs to the screen. You can stop the server by hitt Ctrl-C. 
    * You can now use the convience script to start the server in the background. In the ethereum directory run:
        * cp learnathon/setting-up-a-miner/startgeth.sh .
        * chmod 755 startgeth.sh
        * ./startgeth.sh
        * This pipes the logs to chaindata/logs directory and runs the server in the background.  
    * Thats it. You have started a node **BUT** its not officially connected to the network yet thats coming in the "Adding a Peer". 


* Attaching a console 
    * A console allows you to run commands agains your running geth miner. 
    * Attach a console by running the followin command: 
        * geth attach ipc:/home/ec2-user/ethereum/chaindata/geth.ipc 
    * You should get output like this that ends with a ">" prompt.
    * You are now able to run commands against your miner. 
    * You can now use a convenience script to attach to your miner. In the ethereum directory run:
        * cp learnathon/setting-up-a-miner/attachgeth.sh .
        * chmod 755 attachgeth.sh
        * ./attaachgeth.sh


* Adding a Peer
    * In order to mine in the network, you need to connect to the main node as a peer. 
    * From your geth console, add a peer by executing:
        * admin.addPeer("enode://67a8ef542b9660af9fca02067da6cbd1ff2c594645bd14a19ca90a8bee55753f97676f84a0f4abff97c277baaa4613c3ba32022c59297f32ae5e6903b7ed9b92@52.207.236.211:30303?discport=0")
    * Validating a peer was added. Run this in your geth console:
        * admin.peers
    
    * If output is not an empty array, you have successfully completed the challenge and are mining on my private chain. 
    * The "enode" above points to my Blockchain Host instance that is currently mining. 


## Dissecting the geth command. 

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


