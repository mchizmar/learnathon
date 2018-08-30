pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    enum RentalStage {Available, InRental}
    enum PerUnit { Second, Minute, Hour, Day, Week, Month, Year }

    event RentalRequestedStarted(address requester, uint priceInWei, uint perUnit); 
    event RentalRequested(address requester, uint priceInWei, uint perUnit); 
    event RentalRequestDenied(address requester, uint priceInWei, uint perUnit); 
    event RentalPeriodStarted (uint startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodEnded (uint startTimeInSecondsEpoch, uint endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event PaymentReconciled (uint totalPriceInWei, uint startTimeInSecondsEpoch, uint endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 

    modifier onlyRenter() {
        require (msg.sender == renter, "msg.sender is not the current renter and cannot call this function."); 
        _;
    }

    modifier noActiveRequest() { 
        require(requester == 0, "Currently another address has requested to rent this asset. Try agin later.");
        _;
    }

    modifier isActiveRequest() { 
        require(requester > 0, "Currently there are no requests for this asset.");
        _;
    }

    modifier isNotRented() { 
        require(!isRented, "This asset is rented at this time and this function cannot be executed.");
        _;
    }

    modifier isCurrentlyRented(){
        require(isRented, "This asset is not rented at this time and this function cannot be executed.");
        _;  
    }

    modifier isValidPerUnit(uint _perUnit){
        require(_perUnit >= uint(PerUnit.Second) && _perUnit <= uint(PerUnit.Year), "Invalid PerUnit value. Expected: 0=Second, 1=Minute, 2=Hour, 3=Day, 4=Week, 5=Month, 6=Year");
        _;
    }

    modifier isValidEndTime(uint _endTime){
        require(_endTime > startTimeInSecondsEpoch, "End time provided is prior to the start time.");
        _;
    }

    address requester; 
    uint requestPriceInWei; 
    uint requestPerUnit;
    address renter; 
    RentalStage public rentalStage; 
    uint public priceInWei; 
    uint public perUnit; 
    uint public startTimeInSecondsEpoch; 
    uint public endTimeInSecondsEpoch; 
    bool public isRented; 
    
    constructor () BasicAsset() public {
        isRented = false;         
        rentalStage = RentalStage.Available; 
    }

    //-----------------------------------------------------------------
    // Manage Rental States
    //-----------------------------------------------------------------
    
    function requestRental(uint _priceInWei, uint _perUnit) 
     public noActiveRequest isNotRented isValidPerUnit(_perUnit) {
        emit RentalRequestedStarted(requester, requestPriceInWei, requestPerUnit);    
        requester = msg.sender; 
        requestPriceInWei = _priceInWei; 
        requestPerUnit = _perUnit; 
        emit RentalRequested(requester, requestPriceInWei, requestPerUnit); 
    }

    function denyRentalRequest() 
     public onlyOwner isActiveRequest isNotRented {
        resetRequestVariables();
        emit RentalRequestDenied(requester, requestPriceInWei, requestPerUnit); 
    }

    function startRentalPeriod(uint _startTimeInSecondsEpoch) 
     public onlyOwner isActiveRequest isNotRented { 
        
        renter = requester; 
        priceInWei = requestPriceInWei; 
        perUnit = requestPerUnit; 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        isRented = true; 
        rentalStage = RentalStage.InRental; 
        resetRequestVariables(); 

        emit RentalPeriodStarted(startTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function endRentalPeriod(uint _endTimeInSecondsEpoch) 
     public onlyOwner isCurrentlyRented isValidEndTime (_endTimeInSecondsEpoch){
        
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch; 
        
        //transfer ether from the renter to the owner (or this wallet)
        //uint totalPrice = calculatePriceInWei();

        rentalStage = RentalStage.Available;

        emit RentalPeriodEnded(startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function getRequestInfo() 
     public view onlyOwner isActiveRequest isNotRented returns (address, uint, uint) {
        return  (requester, requestPriceInWei, requestPerUnit); 
    }

    function setIsRented(bool _isRented) public onlyOwner { 
        isRented = _isRented;
    }

    function getCurrentRentalInfo() 
     public view onlyOwner returns (uint, uint, uint, address, address){
        return (startTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter);
    }

    function calculatePriceInWei() internal pure returns (uint){
        return 1; 
    }

    function setRenter(address _renter) public onlyOwner {
        renter = _renter; 
    }
    function getRenter() public view onlyOwner returns (address) { 
        return renter;
    }

    function resetRequestVariables() internal onlyOwner {
        requester = address(0); 
        requestPriceInWei = 0; 
        requestPerUnit = uint(PerUnit.Year)+10;//making sure its out of range
    }

}