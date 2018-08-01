pragma solidity ^0.4.17; 

import "./Asset.sol"; 

/**
    An Asset that persists attributes off-chain. 
    Theory and unnecessary for this lab. Consider removing. 
*/
contract ExtendedAsset is Asset {

    string offChainID; 

    constructor (string _offChainID) Asset() public { 
        offChainID = _offChainID; 
    }
    
}