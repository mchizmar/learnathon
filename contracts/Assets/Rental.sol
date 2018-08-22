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
        -- MOVED -- 
       Note: this code has been moved to RentableAsset to make the dev easier for the learnathon. 
       I think I overengineered this to conform to OOP practices. Contracts are similar to Objects, 
       but the runtime and paradigm are different. Instantiation and constructor parameters are 
       difficult to manage on Ethereum. So I am avoinding them. 

        Should the Rentable asset own this contract? OR should the owner of the Asset own the contract? 
            - The owning addres is an account that has a private key. 
            - Should Asset be a Wallet Contract that can accept paymetns?
            - If the Asset is a Wallet Contract (which I think means it has a private key) then it should own the contract. 
    */
    constructor (address _rentableAsset, address _renter) public Destructible(){ 
        rentableAsset = RentableAsset(_rentableAsset);
        renter = _renter; 
        
        rentalStage = RentalStage.Negotiation;
    }

    /*
        -- MOVED -- 
    */
    function setNegotiatedTerms(uint _priceInWei, uint _perUnit) public onlyOwner {         
        require(rentalStage == RentalStage.Negotiation); 
        require(_perUnit >= uint(PerUnit.Minute) && _perUnit <= uint(PerUnit.Year)); 

        rentalStage = RentalStage.PreRental;
        priceInWei = _priceInWei; 
        perUnit = _perUnit; 

        emit TermsNegotiated(priceInWei, perUnit, address(rentableAsset), renter); 
    }


    /*
        -- MOVED -- 
    */
    function startRentalPeriod(uint256 _startTimeInSecondsEpoch) public { 
        require(!rentableAsset.isRented());
        require(rentalStage == RentalStage.PreRental);
        
        rentableAsset.setIsRented(true); 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        rentalStage = RentalStage.InRental; 

        emit RentalPeriodStarted(startTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter); 
    }

    /*
        -- MOVED -- 
    */
    function endRentalPeriod(uint256 _endTimeInSecondsEpoch) public { 
        require(rentableAsset.isRented());
        require(rentalStage == RentalStage.InRental);
        
        rentableAsset.setIsRented(false);
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch; 
        rentalStage = RentalStage.EndRental; 

        emit RentalPeriodEnded(startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, rentableAsset, renter); 
    }

    /*
        -- MOVED -- 
    */
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