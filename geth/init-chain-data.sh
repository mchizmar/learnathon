## 
# Following reference: https://medium.com/@chim/ethereum-how-to-setup-a-local-test-node-with-initial-ether-balance-using-geth-974511ce712
# 0. This file is created relative to the chaindata directory. Run this fail in the same directory where chaindata exists. 
##
## 1. Before creating the chain, create the accounts first and fund them. Repeat this command for as many accounts you need. 
##
geth --datadir chaindata account new;

# Created accounts below. Output written to chaindata/keystore
# NW150201:learnathon chizmm1$ geth --datadir chaindata account new
# Your new account is locked with a password. Please give a password. Do not forget this password.
# Passphrase: 
# Repeat passphrase: 
# Address: {574ed7ceec9a292daad2c4469391c72ffedefd5d}
# NW150201:learnathon chizmm1$ geth --datadir chaindata account new
# Your new account is locked with a password. Please give a password. Do not forget this password.
# Passphrase: 
# Repeat passphrase: 
# Address: {ab66da44bbde42322b7f9611a6081232530fe7a2}
# NW150201:learnathon chizmm1$ geth --datadir chaindata account new
# Your new account is locked with a password. Please give a password. Do not forget this password.
# Passphrase: 
# Repeat passphrase: 
# Address: {58c6a6eb845f7ebfe08b8d44d97c961c1f81974d}
# NW150201:learnathon chizmm1$ geth --datadir chaindata account new
# Your new account is locked with a password. Please give a password. Do not forget this password.
# Passphrase: 
# Repeat passphrase: 
# Address: {325f30df49e7faa773b2884bd5da4a8648977015}

# --- Genesis file config --- 
# Changed: 
#   - the chainId to 63 
#   - nonce was changed to some number you made up: 
#       "The above fields should be fine for most purposes, although we'd recommend changing the nonce to some random value so you prevent unknown remote nodes from being able to connect to you."
#         https://github.com/ethereum/go-ethereum
#   - set the addresses to the address created above

# {
#  "config": {
#   "chainId": 63,
#   "homesteadBlock": 0,
#   "eip155Block": 0,
#   "eip158Block": 0
#  },
#  "nonce": "0x0000000000015242",
#  "timestamp": "0x0",
#  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
#  "gasLimit": "0x8000000",
#  "difficulty": "0x400",
#  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
#  "coinbase": "0x3333333333333333333333333333333333333333",
#  "alloc": {
#       "574ed7ceec9a292daad2c4469391c72ffedefd5d": {"balance": "0x1337000000000000000000"},
#       "ab66da44bbde42322b7f9611a6081232530fe7a2": {"balance": "0x2337000000000000000000"}, 
#       "58c6a6eb845f7ebfe08b8d44d97c961c1f81974d": {"balance": "0x2337000000000000000000"}, 
#       "325f30df49e7faa773b2884bd5da4a8648977015": {"balance": "0x2337000000000000000000"}
#  }
# }

#
# Initialize the chain with the genesis file information listed above
# ** IMPORTANT - make sure --networkid is the same value as the chainId you specified in the genesis file.
# 
geth --identity "LearnathonChain" --rpc --rpcport 8545 --rpccorsdomain “*” --datadir chaindata/data --port 30303 --nodiscover --rpcapi db,eth,net,web3,personal --networkid 63 --maxpeers 2 --verbosity 6 init chaindata/genesis.json 2>> chaindata/logs/`date +%s`.log

# Attach a geth console
geth --identity "LearnathonChain" --rpc --rpcport 8545 --rpccorsdomain “*” --datadir chaindata/data --port 30303 --nodiscover --rpcapi db,eth,net,web3,personal --networkid 63 console

# Connect Mist browser to the private chain
/Applications/Mist.app/Contents/MacOS/Mist --rpc http://localhost:8545

# Migrating contracts to this chain via truffle
truffle migrate --network learnathon

