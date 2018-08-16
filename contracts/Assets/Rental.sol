pragma solidity ^0.4.17; 

import "openzeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "./RentableAsset.sol"; 

/**
    Make this ownable when OpenZepellin libs are included. 
*/ 
contract Rental is Destructible { 
    
    enum RentalStage { Negotiation, PreRental, InRental, EndRental, ReconcilePayment, PaymentReconciled}
    enum PerUnit { Minute, Hour, Day, Week, Month, Year }

    event TermsNegotiated (uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodStarted (uint256 startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodEnded (uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event PaymentReconciled (uint256 totalPriceInWei, uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 

    RentableAsset public rentableAsset;    
    RentalStage public rentalStage; 
    address public renter; 
    uint public priceInWei; 
    uint public perUnit; 
    uint256 public startTimeInSecondsEpoch; 
    uint256 public endTimeInSecondsEpoch; 
 
    /**
        Should the Rentable asset onw this contract? Yes OR should the owner of the Asset own the contract. 
        Me thinks the asset should own the contact. 
    */
    constructor (address _rentableAsset, address _renter) public Destructible(){ 
        /*
            Creating a contract instance from another contract
            TODO: How will this fail if _rentableAsset is not of type RentableAsset? 
        */
        rentableAsset = RentableAsset(_rentableAsset);
        renter = _renter; 
        
        rentalStage = RentalStage.Negotiation;
    }

    function setNegotiatedTerms(uint _priceInWei, uint _perUnit) public onlyOwner {         
        require(rentalStage == RentalStage.Negotiation); 
        require(_perUnit >= uint(PerUnit.Minute) && _perUnit <= uint(PerUnit.Year)); 

        rentalStage = RentalStage.PreRental;
        priceInWei = _priceInWei; 
        perUnit = _perUnit; 

        emit TermsNegotiated(priceInWei, perUnit, address(rentableAsset), renter); 
    }

    function startRentalPeriod(uint256 _startTimeInSecondsEpoch) public { 
        require(!rentableAsset.isRented());
        require(rentalStage == RentalStage.PreRental);
        
        rentableAsset.setIsRented(true); 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        rentalStage = RentalStage.InRental; 

        emit RentalPeriodStarted(startTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter); 
    }

    function endRentalPeriod(uint256 _endTimeInSecondsEpoch) public { 
        require(rentableAsset.isRented());
        require(rentalStage == RentalStage.InRental);
        
        rentableAsset.setIsRented(false);
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch; 
        rentalStage = RentalStage.EndRental; 

        emit RentalPeriodEnded(startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter); 
    }

    function reconcilePayment() public onlyOwner payable { 
        require(rentalStage == RentalStage.EndRental); 
        require(!rentableAsset.isRented()); 

        rentalStage = RentalStage.ReconcilePayment;

        //reconcile code
        uint256 totalPrice = calculatePriceInWei(); 

        rentalStage = RentalStage.PaymentReconciled;
        emit PaymentReconciled(totalPrice, startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter); 
    }

    /**
        Returns
        uint256 startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter
    */
    function getCurrentRentalInfo() public view onlyOwner returns (uint256, uint, uint, address, address){
        return (startTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter);
    }

    function calculatePriceInWei() internal pure returns (uint256){
        return 1; 
    }

    function getRenter() public view onlyOwner returns (address) { 
        return renter;
    }
}