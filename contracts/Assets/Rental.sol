pragma solidity ^0.4.17; 

import "./RentableAsset.sol"; 

/**
    Make this ownable when OpenZepellin libs are included. 
*/ 
contract Rental { 
    
    enum RentalStage { Negotiation, PreRental, InRental, EndRental, ReconcilePayment}
    enum PerUnit { Minute, Hour, Day, Week, Month, Year }

    event TermsNegotiated(uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodStarted(uint priceInWei, uint perUnit, address rentableAsset, address renter); 

    address public owner; 
    RentableAsset public rentableAsset;    
    RentalStage public rentalStage; 
    address public renter; 
    uint public priceInWei; 
    uint public perUnit; 
 
    constructor (address _rentableAsset, address _renter){ 
        
        owner = msg.sender; 
        
        //Creating a contract instance from another contract
        //How will this fail if _rentableAsset is not of type RentableAsset? 
        rentableAsset = RentableAsset(_rentableAsset);
        renter = _renter; 
        rentalStage = RentalStage.Negotiation;
    }

    function setNegotiatedTerms(uint _priceInWei, uint _perUnit) /* onlyOwner */ {         
        require(rentalStage == RentalStage.Negotiation); 
        require(_perUnit >= uint(PerUnit.Minute) && _perUnit <= uint(PerUnit.Year)); 

        rentalStage = RentalStage.PreRental;
        priceInWei = _priceInWei; 
        perUnit = _perUnit; 

        emit TermsNegotiated(priceInWei, perUnit, address(rentableAsset), renter); 
    }

    function startRentalPeriod() public { 
        require(!rentableAsset.isRented());
        require(rentalStage == RentalStage.PreRental);
        
        rentableAsset.setIsRented(true); 
        rentalStage = RentalStage.InRental; 

        emit RentalPeriodStarted(priceInWei, perUnit, rentableAsset, renter); 
    }

    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    // 1. Are there other functions needed when InRental? 
    // 2. Write EndRental Code
    // 3. Write code for reconciliation process  
    // 4. Destroy the contract? 
    //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


    //set visibility to onlyOwner when OpenZeppelin is installed
    function getRenter() /* onlyOwner */ returns (address) { 
        return renter;
    }
}