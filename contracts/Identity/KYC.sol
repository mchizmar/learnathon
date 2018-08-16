pragma solidity ^0.4.17; 

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract KYC is Ownable {
    
    address[] public verifiedBy; //array of V 

    constructor() public Ownable() { 
    }

    function addVerifier(address verifier) public onlyOwner{ 
        verifiedBy.push(verifier);
    }
}