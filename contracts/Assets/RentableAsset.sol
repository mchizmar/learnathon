pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    enum RentalStage {Available, InRental, Reconciliation}
    enum PerUnit { Second, Minute, Hour, Day, Week, Month, Year }

    //Debugging 
    event ModifierOnlyOwnerPassed(); 
    event ModifierOnlyOwnerOrRenterPassed(); 
    event ModifierNoActiveRequestPassed(); 
    event ModifierIsActiveRequestPassed(); 
    event ModifierIsNotRenteredPassed(); 
    event ModifierIsCurrentlyRentedPassed(); 
    event ModifierIsValidPerUnitPassed(); 
    event ModifierIsValidEndTimePassed(); 
    event ModifierIsInReconciliationPassed(); 
    event ModifierIsTotalPaymentPassed(); 
    
    event RentalRequestedStarted(address requester, uint priceInWei, uint perUnit); 
    event RentalRequested(address requester, uint priceInWei, uint perUnit); 
    event RentalRequestDenied(address requester, uint priceInWei, uint perUnit); 
    event StartRental (uint startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event EndRental (uint totalPriceInWei, uint startTimeInSecondsEpoch, uint endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event Reset (); 
    event PaymentReconciled(uint totalPriceWei, address renter);

    modifier onlyRenter() {
        require (msg.sender == renter, "msg.sender is not the current renter and cannot call this function."); 
        emit ModifierOnlyOwnerPassed();
        _;
    }

    modifier onlyOwnerOrRenter() {
        require (msg.sender == renter || msg.sender == owner, "msg.sender is not the current renter and cannot call this function."); 
        emit ModifierOnlyOwnerOrRenterPassed();
        _;
    }

    modifier noActiveRequest() { 
        require(requester == 0, "Currently another address has requested to rent this asset. Try agin later.");
        emit ModifierNoActiveRequestPassed();
        _;
    }

    modifier isActiveRequest() { 
        require(requester > 0, "Currently there are no requests for this asset.");
        emit ModifierIsActiveRequestPassed();
        _;
    }

    modifier isNotRented() { 
        require(!isRented, "This asset is rented at this time and this function cannot be executed.");
        emit ModifierIsNotRenteredPassed();
        _;
    }

    modifier isCurrentlyRented(){
        require(isRented, "This asset is not rented at this time and this function cannot be executed.");
        emit ModifierIsCurrentlyRentedPassed();
        _;  
    }

    modifier isValidPerUnit(uint _perUnit){
        require(_perUnit >= uint(PerUnit.Second) && _perUnit <= uint(PerUnit.Year), "Invalid PerUnit value. Expected: 0=Second, 1=Minute, 2=Hour, 3=Day, 4=Week, 5=Month, 6=Year");
        emit ModifierIsValidPerUnitPassed();
        _;
    }

    modifier isValidEndTime(uint _endTime){
        require(_endTime > startTimeInSecondsEpoch, "End time provided is prior to the start time.");
        emit ModifierIsValidEndTimePassed(); 
        _;
    }

    modifier isInReconciliation(){ 
        require(rentalStage == RentalStage.Reconciliation, "The rental period must have ended and be in reconcilitation stage..");
        emit ModifierIsInReconciliationPassed();
        _;
    }

    modifier isTotalPayment(){
        require(msg.value == totalPriceInWei, "The rental period must have ended and be in reconcilitation stage..");
        emit ModifierIsTotalPaymentPassed(); 
        _;
    }

    address public requester; 
    uint public requestPriceInWei; 
    PerUnit public requestPerUnit;
    address public renter; 
    uint public priceInWei; 
    uint public startTimeInSecondsEpoch; 
    uint public endTimeInSecondsEpoch; 
    bool public isRented; 
    PerUnit public perUnit; 
    RentalStage public rentalStage; 
    uint public totalPriceInWei;
    uint public totalTimeSeconds;
    uint public totalPerUnit; 

    
    constructor () BasicAsset() public {
        isRented = false;         
        rentalStage = RentalStage.Available; 
    }

    //-----------------------------------------------------------------
    // Manage Rental States
    //-----------------------------------------------------------------
    
    function requestRental(uint _priceInWei, uint _perUnit) 
     public noActiveRequest isNotRented isValidPerUnit(_perUnit) {
        emit RentalRequestedStarted(requester, requestPriceInWei, uint(requestPerUnit));    
        requester = msg.sender; 
        requestPriceInWei = _priceInWei; 
        requestPerUnit = PerUnit(_perUnit); 
        emit RentalRequested(requester, requestPriceInWei, uint(requestPerUnit)); 
    }

    function denyRentalRequest() 
     public onlyOwner isActiveRequest isNotRented {
        resetRequestVariables();
        emit RentalRequestDenied(requester, requestPriceInWei, uint(requestPerUnit)); 
    }

    function startRental(uint _startTimeInSecondsEpoch) 
     public onlyOwner isActiveRequest isNotRented { 
        
        renter = requester; 
        priceInWei = requestPriceInWei; 
        perUnit = requestPerUnit; 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        isRented = true; 
        rentalStage = RentalStage.InRental; 
        resetRequestVariables(); 

        emit StartRental(startTimeInSecondsEpoch, priceInWei, uint(perUnit), address(this), renter); 
    }

    function endRental(uint _endTimeInSecondsEpoch) 
     public  onlyRenter isCurrentlyRented isValidEndTime (_endTimeInSecondsEpoch){
        
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch;         
        totalTimeSeconds = endTimeInSecondsEpoch-startTimeInSecondsEpoch; 
        totalPerUnit = convertToPerUnitValue(totalTimeSeconds); 
        totalPriceInWei = totalPerUnit * priceInWei; 
        rentalStage = RentalStage.Reconciliation;

        emit EndRental(totalPriceInWei, startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, uint(perUnit), address(this), renter); 
    }

    function reconcilePayment() 
     public payable onlyRenter isTotalPayment {
        owner.transfer(totalPriceInWei); 
        reset();
        PaymentReconciled(totalPriceInWei, renter);
    }
    
    function getRequestInfo() 
     public view onlyOwner isActiveRequest isNotRented returns (address, uint, uint) {
        return  (requester, requestPriceInWei, uint(requestPerUnit)); 
    }

    function setIsRented(bool _isRented) 
     public onlyOwner { 
        isRented = _isRented;
    }

    function getCurrentRentalInfo() 
     public view onlyOwner returns (uint, uint, uint, address, address){
        return (startTimeInSecondsEpoch, priceInWei, uint(perUnit), address(this), renter);
    }

    function convertToPerUnitValue(uint totalSec) internal view returns (uint){
        if (perUnit == PerUnit.Second){
            return totalSec; 
        }
        else if (perUnit == PerUnit.Minute){
            return totalSec / 60; 
        }
        else if (perUnit == PerUnit.Hour){
            return totalSec / 60 / 60; 
        }
        else if (perUnit == PerUnit.Day){
            return totalSec / 60 / 60 / 24;
        }
        return 0; 
    }
    
    function getRenter() 
     public view onlyOwner returns (address) { 
        return renter;
    }

    function getTotalPriceInWei() 
     public view onlyOwnerOrRenter returns (uint) { 
        return totalPriceInWei;
    }

    function reset() public { 
        resetRequestVariables(); 
        priceInWei = 0; 
        perUnit = PerUnit.Second; 
        startTimeInSecondsEpoch = 0; 
        endTimeInSecondsEpoch = 0;
        isRented = false; 
        rentalStage = RentalStage.Available;
        totalPriceInWei = 0;
        renter = address(0); 
        emit Reset();
    }


    function resetRequestVariables() internal onlyOwner {
        requester = address(0); 
        requestPriceInWei = 0; 
        requestPerUnit = PerUnit.Second;//making sure its out of range
    }

}