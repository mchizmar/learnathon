var BasicAsset = artifacts.require("./Assets/BasicAsset.sol");

contract ('BasicAssetTest', function (accounts) {
  
  it("desc is set.", function () {

    return BasicAsset.deployed()
      .then(function(basicAssetInstance){
        return basicAssetInstance.desc.call();
      })
      .then (function(desc){
        assert.equal(desc, "description", "BasicAsset.desc expected to be set"); 
      });
  
    });

});

