pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Assets/BasicAsset.sol";

contract TestBasicAsset {
    function testBasicAssetContractInternals() {
        BasicAsset basicAsset = BasicAsset(DeployedAddresses.BasicAsset());
        Assert.isNotZero(DeployedAddresses.BasicAsset(), "expected Asset address not to be zero when deployed." ); 
        Assert.equal(basicAsset.owner(), msg.sender, "msg.sender should is the owner of the contract."); 
    }

    function testBasicAssetDescriptionIsSet() { 
        BasicAsset basicAsset = BasicAsset(DeployedAddresses.BasicAsset());
        Assert.equal(basicAsset.desc(), "description", "BasicAsset.desc should be set."); 
    }
}
