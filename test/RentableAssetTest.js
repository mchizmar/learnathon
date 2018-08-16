var RentableAsset = artifacts.require("./Assets/RentableAsset.sol");

contract ('RentableAssetTest', function (accounts) {

  it("should default isRented to false (using async/await).",  () => {
    async function run() {
      let rentableAssetInstance = await RentableAsset.deployed(); 
      //let isRented = await rentableAssetInstance.isRented.call(account[0]);
      let isRented = await rentableAssetInstance.isRented.call(address[0]);
      console.log("LOG: isRented returned "+ JSON.stringify(isRented));
      assert.equal(false, true, "RentableAsset.isRented() should default to false.");    
    }
    run(); 
  });

  it("should default isRented to false.", function () {

    return RentableAsset.deployed()
      .then(function(rentableAssetInstance){
        return rentableAssetInstance.isRented();
      })
      .then(function(result){
        assert.equal(false, result, "RentableAsset.isRented() should default to false.");    
      });
  });

    it("should default isRented to false.", function () {

      var rentableAssetInstance; 
      return RentableAsset.deployed()
        .then(function(contractInstance){
          rentableAssetInstance = contractInstance; 
          return rentableAssetInstance.setIsRented(true, {from: accounts[0]}); 
        })
        .then(function(result){
          //this "then" represents the transaction that took place on the blockchain. 
          console.log("LOG: result after setting isRented()- "+JSON.stringify(result)); 
          return rentableAssetInstance.isRented();
        })
        .then(function(result){
          console.log("LOG: result after calling is rented isRented()- "+JSON.stringify(result)); 
          assert.equal(true, result, "RentableAsset.isRented() should default to false.");    
        })
    });
  })     