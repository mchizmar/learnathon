pragma solidity ^0.4.17; 

contract Rental { 
    
    enum RentalStage { 
        Negotiation, 
        Downpayment,
        StartRental, 
        InRental, 
        EndRental, 
        Payment
    }
    event TermsNegotiated(); 

    address public owner; 
    address public rentalAsset;    
    RentalStage public rentalStage; 
    address renter; 

    constructor(address _rentalAsset, address _renter){ 
        owner = msg.sender; 
        rentalAsset = _rentalAsset;
        renter = _renter; 
        rentalStage = RentalStage.Negotiation;
    }

    function setNegotiatedTerms(uint priceInWei, uint perUnit) /* onlyOwner */ { 
        
    }

    //set visibility to onlyOwner when OpenZeppelin is installed
    function getRenter() /* onlyOwner */ returns (address) { 
        return renter;
    }
}