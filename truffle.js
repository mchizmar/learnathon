// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*' // Match any network id
    }, 
    learnathon: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '63',
      gas: 4712388, // default gas value
      from: '0x574ed7ceec9a292daad2c4469391c72ffedefd5d' // account used to deploy the contract
    }
  }
}

