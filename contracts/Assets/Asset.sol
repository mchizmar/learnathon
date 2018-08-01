pragma solidity ^0.4.17; 

/**
    TODO Import OpenZepellin libs for Ownable...
*/
contract Asset /*is Ownable*/ {

    address owner; 
    constructor (){
        owner = msg.sender; 
    }
}