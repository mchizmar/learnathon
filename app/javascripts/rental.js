// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
//import metacoin_artifacts from '../../build/contracts/MetaCoin.json'
import rentable_asset_artifacts from '../../build/contracts/RentableAsset.json'

//Sets the rentable asset from the ABI located in json file above
var RentableAssetContract = contract(rentable_asset_artifacts); 


// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.ra = RentableAssetContract;

window.App = {

  RentableAsset: RentableAssetContract, 
  
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    //MetaCoin.setProvider(web3.currentProvider);
    RentableAssetContract.setProvider(web3.currentProvider);
    console.log(RentableAssetContract);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0]; 

      App.setRenter(); 
      App.isRented(); 
      App.outputBasicInfo(); 

    });
  },

  outputBasicInfo: function() { 
    //DEBUG function - delete it  
    RentableAssetContract.deployed().then(function(instance){
      document.getElementById("rentalassetaddress").innerText = instance.address;
       web3.eth.getBalance(instance.address, function(err,res){
        document.getElementById("rentalassetbalance").innerText = res;
       });
    })
    console.log("ACCOUNT : " + account);

    web3.eth.getBalance(account, function(err, res){
      if (err) {
        console.log("Error getting balance for Current account : " + err);

      } else {
        console.log("Current account is : " + account.address);
        console.log("Current account balance is : " + res);
      }
    });
    RentableAssetContract.deployed().then(function(instance){
      instance.owner.call().then(function(val){
        console.log("RentableAsset owner: "+val);
      });

      instance.getCurrentRentalInfo.call().then(function(val){
        console.log("Current rental info : "+val);
      });

      instance. getRequestInfo.call().then(function(val){
        console.log("Request Info : "+val);
      });
    });

  }, 

  setRenter: function() {
  }, 
  
  isRented: function(){
    RentableAssetContract.deployed().then(function(instance){
      instance.isRented.call().then(function(val){
        console.log("RentableAsset isRented: "+val);
      });
    });    
  }, 

  setNegotiatedTerms: function(){

  }, 

  startRentalPeriod: function(){

  }, 
  
  endRentalPeriod: function(){

  }, 

  reconcilePayment: function(){ 

  }
};

window.addEventListener('load', function() {

  if (typeof web3 !== 'undefined') {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    console.warn("Using web3 detected from external source.");
    window.web3 = new Web3(web3.currentProvider);
  } else {
    //use localhost
    console.warn("No web3 detected. Falling back to http://127.0.0.1:8545.");
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
  }
  App.start();

});