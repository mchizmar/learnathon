pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    enum RentalStage { Negotiation, PreRental, InRental, EndRental, ReconcilePayment, PaymentReconciled}
    enum PerUnit { Minute, Hour, Day, Week, Month, Year }

    event TermsNegotiated (uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodStarted (uint256 startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodEnded (uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event PaymentReconciled (uint256 totalPriceInWei, uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 

    RentalStage public rentalStage; 
    address public renter; 
    uint public priceInWei; 
    uint public perUnit; 
    uint256 public startTimeInSecondsEpoch; 
    uint256 public endTimeInSecondsEpoch; 
    bool public isRented; 
    
    constructor () BasicAsset() public {
        isRented = false;         
        rentalStage = RentalStage.Negotiation;
    }

    //-----------------------------------------------------------------
    // Manage Rental States
    //-----------------------------------------------------------------

    function setIsRented(bool _isRented) public onlyOwner { 
        isRented = _isRented;
    }

    function setNegotiatedTerms(uint _priceInWei, uint _perUnit) public onlyOwner {         
        require(rentalStage == RentalStage.Negotiation, "Asset rental stage is not in Negotiation and must be before starting a new rental."); 
        require(_perUnit >= uint(PerUnit.Minute) && _perUnit <= uint(PerUnit.Year), "Invalid Units provided"); 

        rentalStage = RentalStage.PreRental;
        priceInWei = _priceInWei; 
        perUnit = _perUnit; 

        emit TermsNegotiated(priceInWei, perUnit, address(this), renter); 
    }

    function startRentalPeriod(uint256 _startTimeInSecondsEpoch) public { 
        require(!isRented, "Asset is currently being rented. Cannot start a new period until the asset becomes available.");
        require(rentalStage == RentalStage.PreRental, "Asset rental stage is not in Pre-rental and must be before starting a new rental.");
        
        isRented = true; 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        rentalStage = RentalStage.InRental; 

        emit RentalPeriodStarted(startTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function endRentalPeriod(uint256 _endTimeInSecondsEpoch) public { 
        require(isRented, "Asset is not flagged as rented. Cannot end a period when then asset is not rented." );
        require(rentalStage == RentalStage.InRental, "Asset rental stage is not In-rental. Cannot end a period not in-rental.");
        require(_endTimeInSecondsEpoch > startTimeInSecondsEpoch, "End time provided is prior to the start time.");
        
        isRented = false;
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch; 
        rentalStage = RentalStage.EndRental; 

        emit RentalPeriodEnded(startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function reconcilePayment() public onlyOwner payable { 
        require(rentalStage == RentalStage.EndRental, "Rental stage must be in end rental to reconcile payment."); 
        require(!isRented, "Asset is flagged as rented. Reconcilliation cannot occur on a rented asset."); 

        rentalStage = RentalStage.ReconcilePayment;
        uint256 totalPrice = calculatePriceInWei(); 

        rentalStage = RentalStage.PaymentReconciled;
        emit PaymentReconciled(totalPrice, startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function getCurrentRentalInfo() public view onlyOwner returns (uint256, uint, uint, address, address){
        return (startTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter);
    }

    function calculatePriceInWei() internal pure returns (uint256){
        return 1; 
    }

    function getRenter() public view onlyOwner returns (address) { 
        return renter;
    }

    //-----------------------------------------------------------------
    //-----------------------------------------------------------------


    function destroy() public onlyOwner {
        require(!isRented, "Asset is flagged as rented. Cannot destroy a rented asset."); 
        super.destroy();
    }

    function destroyAndSend(address _recipient) public onlyOwner {
        require(!isRented, "Asset is flagged as rented. Cannot destroy a rented asset."); 
        super.destroyAndSend(_recipient);
    }
}