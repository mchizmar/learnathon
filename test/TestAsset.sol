pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Assets/Asset.sol";

contract TestAsset {

  function testAssetIsNotNull() {
    Asset asset = Asset(DeployedAddresses.Asset());
    Assert.isNotZero(DeployedAddresses.Asset(), "expected Asset address not to be zero when deployed." ); 
  }
}
