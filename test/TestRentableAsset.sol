pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Assets/RentableAsset.sol";

contract TestRentableAsset {

    function testRentableAssetContractInternals() {
        RentableAsset rentableAsset = RentableAsset(DeployedAddresses.RentableAsset());
        Assert.isNotZero(DeployedAddresses.RentableAsset(), "expected Asset address not to be zero when deployed." ); 
        Assert.equal(rentableAsset.owner(), msg.sender, "msg.sender should is the owner of the contract."); 
    }

    function testRentableAssetDescriptionIsSet() { 
        RentableAsset rentableAsset = RentableAsset(DeployedAddresses.RentableAsset());
        Assert.equal(rentableAsset.desc(), "rentable description", "RentableAsset.desc should be set."); 
    }

    function testRentableAssetIsRentedDefaultsToFalse() { 
        RentableAsset rentableAsset = RentableAsset(DeployedAddresses.RentableAsset());
        Assert.equal(rentableAsset.desc(), "rentable description", "RentableAsset.desc should be set."); 
        Assert.isFalse(rentableAsset.isRented(),"RentableAsset.isRented default to false."); 
    }

    function testRentableAssetIsRented() { 
        RentableAsset rentableAsset = RentableAsset(DeployedAddresses.RentableAsset());
        Assert.equal(rentableAsset.desc(), "rentable description", "RentableAsset.desc should be set."); 
        Assert.isFalse(rentableAsset.isRented(),"RentableAsset.isRented default to false."); 

        //TODO: How do you call a state changing function from a contract? 
        //Assert.isTrue(rentableAsset.isRented(),"RentableAsset.isRented should be true."); 
        //rentableAsset.setIsRented(true, {from:eth.accounts[0], gas: 400000});
    }

}
