# Mine the Blockchain Challenge

In this challenge you are going to set up an Ethereum miner for a private  network.   

## Getting Started

[Etherum](https://www.ethereum.org/) 
"Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed 
without any possibility of downtime, censorship, fraud or third-party interference.

These apps run on a custom built blockchain, an enormously powerful shared global infrastructure that can 
move value around and represent the ownership of property."

Ethereum Smart Contacts are applicaitons written in the Solidity programming language that run on an Ethereum network. The main purpose of the contracts is to control transactions and exchange of value between accounts on the network. The currency of echange on the network is called ether and it is the second most valued public cryptocurrency behind Bitcoin. 

The main Ethereum network is public and anyone with ether can deploy smart contracts to it. Miners are nodes in this decentralized network that execute smart contract code and verify all transactions on they make. The state of these transactions are stored in a Blockchain database and an exact copy of it is ditributed to all nodes in the network. A miner that is the first to verify a specific set of transactions, and all nodes agree on this verification, gets ether as a reward.

Ethereum is also a platform that can be used to establish a private network that has all of the functionality of the public side, but unlike the public side, an admisitrator governs who is allowed to run a node in the network. When business partners choose to participated in a decentralized private network, its called a consortium. 

I have created a private network and am hosting it on an AWS EC2 Medium instance running Amazon's Linux. As a demo I have created a rental app using web and conversational apps that interact with a smart contract deployed on the network. 

This challenge is to to create a mining node and connect it to my private network. 


### Prerequisites
Geth - Ethereum Client (Node) Software


### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

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
