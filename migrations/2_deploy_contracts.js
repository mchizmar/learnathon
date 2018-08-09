var Asset = artifacts.require("./Assets/Asset.sol"); 
var BasicAsset = artifacts.require("./Assets/BasicAsset.sol"); 
var RentableAsset = artifacts.require("./Assets/RentableAsset.sol"); 

module.exports = function(deployer) {
  deployer.deploy(Asset); 
  deployer.deploy(BasicAsset, "description"); 
  deployer.deploy(RentableAsset, "rentable description"); 

};
