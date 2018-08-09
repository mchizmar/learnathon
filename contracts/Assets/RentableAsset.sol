pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    bool public isRented; 

    constructor (string _desc) BasicAsset(_desc) public {
        isRented = false; 
    }

    function setIsRented(bool _isRented) onlyOwner public { 
        isRented = _isRented;
    }
    
    function destroy() onlyOwner public {
      require(!isRented); 
      super.destroy();
    }

    function destroyAndSend(address _recipient) onlyOwner public {
      require(!isRented); 
      super.destroyAndSend(_recipient);
    }
}