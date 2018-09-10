# Mine the Blockchain Challenge

In this challenge you are going to set up an Ethereum miner for a private  network.   

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

This challenge is to to create a mining node and connect it to my private network. 

### Prerequisites
Downloading and install the necessary software

* Create an Amazon EC2 Instance to host your miner
    * [Log into AWS console](https://nwblockchain.signin.aws.amazon.com/console)
    * Select EC2 under the Services Menu
    * Select Launch Instance Button
        * Select: Amazon Linux 2 AMI (HVM), SSD Volume Type
        * Select Instance Type : t2.medium
        * Select Review and Launch
        * Create your key file you will use to secure login/ssh to your new machine and save for later. You will need to use PuTTy or the command line. 
    * Enable Security Groups to enable Inbounf SSH and Blockchain connections to your server. 
        * In the left hand navigation select Network and Security/Security Groups. 
        * Select the Create Security Group
            * Give the group a name and add the *inbound* groups displayed in the provided image. 




* Checkout the Github project t 
    * https://github.nwie.net/chizmm1/learnathon

* [Go Ethereum - Geth](https://geth.ethereum.org/): Ethereum Protocol Implementation
    * [Download Geth here.](https://geth.ethereum.org/downloads/). Choose the correct installation for you OS.
    * Geth is sofware used to configure miners and interact on an Ethereum network. 

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


## Creating a Miner
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





### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
