pragma solidity ^0.4.17; 

import "./ExtendedAsset.sol";

/** 
    An ExtendedAsset the persists information on the IPFS (Interplanetary File System). 
    Other examples are files that exist on the FileCoin network. 
    Theory and unnecessary for this lab. Consider removing. 

*/
contract IpfsAsset is ExtendedAsset{
    string ipfsID; 

    constructor (string _ipfsID) ExtendedAsset(_ipfsID) public {
        ipfsID = offChainID; 
    }
}