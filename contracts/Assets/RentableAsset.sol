pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    bool public isRented; 

    constructor (string _desc) BasicAsset(_desc) public {
        isRented = false; 
    }

    function setIsRented(bool _isRented) public /*onlyOwner*/ { 
        isRented = _isRented;
    }
}