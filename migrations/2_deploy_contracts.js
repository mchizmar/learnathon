var Asset = artifacts.require("./Assets/Asset.sol"); 
var BasicAsset = artifacts.require("./Assets/BasicAsset.sol"); 
var RentableAsset = artifacts.require("./Assets/RentableAsset.sol"); 

module.exports = function(deployer, network) {
  deployer.deploy(Asset); 
  deployer.deploy(BasicAsset); 
  deployer.deploy(RentableAsset);       

  // if (network == "learnathon"){
    
  //   deployer.deploy(Asset); 
  //   deployer.deploy(BasicAsset);
  //   deployer.deploy(RentalAsset); 

  // } else {
    
  
  // }
};
