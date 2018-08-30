// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";
import "bootstrap/dist/css/bootstrap.css";
import "jquery/dist/jquery.js";

import * as $ from "jquery";

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

window.App = {

  RentableAsset: RentableAssetContract, 

  start: function() {
    var self = this;

    //bootstrap the provider
    RentableAssetContract.setProvider(web3.currentProvider);

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

      //watch for account changes 
      var accountInterval = setInterval(function() {
        if (web3.eth.accounts[0] !== account) {
          account = web3.eth.accounts[0];
          console.log("MetaMaskAccountChanged to " + account)          
          
           $("#currentlySelectedAccount").text(account);
          web3.eth.getBalance(account, function(err, res){
            if (err) {
              console.log("Error getting balance for Current account : " + err);      
            } else {
              $("#currentlySelectedAccountBalance").text(res); 
            }
          });
      
        }
      }, 100);

      App.listenToEvents(); 
      App.outputBasicInfo(); 

    });
  },

  outputBasicInfo: function() { 
    
    $("#currentlySelectedAccount").text(account);
    web3.eth.getBalance(account, function(err, res){
      if (err) {
        console.log("Error getting balance for Current account : " + err);      
      } else {
        $("#currentlySelectedAccountBalance").text(res); 
      }
    });

    RentableAssetContract.deployed().then(function(instance){
      
      $("#rentalAssetAddress").val(instance.address);      

      instance.owner.call().then(function(val){
        $("#ownerAddressText").val(val);
      });

      instance.isRented.call().then(function(val){
        $("#isRented").val(val);
      });

      instance.getCurrentRentalInfo.call().then(function(val){
        $("#rentalInfo").val(val);
      });

      instance.getRequestInfo.call().then(function(res){
        $("#requestInfo").val(res);
      });

      web3.eth.getBalance(instance.address, function(err,res){
        $("#rentalAssetBalance").val(res);
      });
    })    
  }, 
  
  requestRental: function(){
    
    var priceInWei = parseInt($("#requestRentalPriceInWei").val());
    var priceUnit = parseInt($("#requestRentalPriceUnit").val());
    
    console.log("calling requestRental()"); 
    
    RentableAssetContract.deployed().then(function(instance){

      instance.requestRental.sendTransaction(priceInWei, priceUnit, {from: account, gas: 500000})
        .then(function(res){
          console.log("requestRental transaction hash : " + res); }
        )
        .catch(function(err){
          console.log("requestRental transaction err : " + err); }
        )
    })
  },
  denyRentalRequest: function(){
    
    
    console.log("calling denyRental()"); 
    
    RentableAssetContract.deployed().then(function(instance){
      instance.denyRentalRequest.sendTransaction({from: account, gas: 500000})
        .then(function(res){
          console.log("denyRentalRequest transaction hash : " + res); }
        )
        .catch(function(err){
          console.log("denyRentalRequest transaction err : " + err); }
        )
    })
  },

  isRented: function(){
    RentableAssetContract.deployed().then(function(instance){
      instance.isRented.call().then(function(val){
        console.log("RentableAsset isRented: "+val);
      });
    });    
  }, 
  
  listenToEvents: function() {
    var self = this;
    var contract;

    console.log("listening to events")
    RentableAssetContract.deployed().then(function(instance) {
      var eventRentalRequested = instance.RentalRequested().watch(function(error, event) {
        if (error){
          console.log(error);
        } else {
          console.log(event);
        }
      });
    });

    RentableAssetContract.deployed().then(function(instance) {
      var eventRentalRequestDenied = instance.RentalRequestDenied().watch(function(error, event) {
        if (error){
          console.log(error);
        } else {
          console.log(event);
        }
      });
    });

    // RentableAssetContract.deployed().then(function(instance) {
    //   var eventRentalRequestStarted = instance.RentalRequestStarted().watch(function(error, event) {
    //     if (error){
    //       console.log(error);
    //     } else {
    //       console.log(event);
    //     }
    //   });
    // });

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