pragma solidity ^0.4.17;

import "./BasicAsset.sol"; 

contract RentableAsset is BasicAsset { 
    
    enum RentalStage {Available, InRental}
    enum PerUnit { Second, Minute, Hour, Day, Week, Month, Year }

    event RentalPeriodStarted (uint256 startTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event RentalPeriodEnded (uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 
    event PaymentReconciled (uint256 totalPriceInWei, uint256 startTimeInSecondsEpoch, uint256 endTimeInSecondsEpoch, uint priceInWei, uint perUnit, address rentableAsset, address renter); 

    address renter; 
    RentalStage public rentalStage; 
    uint public priceInWei; 
    uint public perUnit; 
    uint256 public startTimeInSecondsEpoch; 
    uint256 public endTimeInSecondsEpoch; 
    bool public isRented; 
    
    constructor () BasicAsset() public {
        isRented = false;         
        rentalStage = RentalStage.Available; 
    }

    //-----------------------------------------------------------------
    // Manage Rental States
    //-----------------------------------------------------------------
    /**
       Start a rental period for this Asset at the price, unit of time and the start time (milliseconds in compueter epoch parlance). 
     */
    function startRentalPeriod(address _renter, uint _priceInWei, uint _perUnit, uint256 _startTimeInSecondsEpoch) public onlyOwner { 
        require(!isRented, "Asset is currently being rented. Cannot start a new period until the asset becomes available.");
        require(rentalStage == RentalStage.Available, "Asset rental stage is not in Pre-rental and must be before starting a new rental.");
        require(_perUnit >= PerUnit.Second && _perUnit <= PerUnit.Year, "Invalid PerUnit value. Expected: 0=Second, 1=Minute, 2=Hour, 3=Day, 4=Week, 5=Month, 6=Year");
        
        renter = _renter; 
        isRented = true; 
        priceInWei = _priceInWei; 
        perUnit = _perUnit; 
        startTimeInSecondsEpoch = _startTimeInSecondsEpoch; 
        rentalStage = RentalStage.InRental; 

        emit RentalPeriodStarted(startTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }

    function endRentalPeriod(uint256 _endTimeInSecondsEpoch) public onlyOwner { 
        require(isRented, "Asset is not flagged as rented. Cannot end a period when then asset is not rented." );
        require(rentalStage == RentalStage.InRental, "Asset rental stage is not In-rental. Cannot end a period not in-rental.");
        require(_endTimeInSecondsEpoch > startTimeInSecondsEpoch, "End time provided is prior to the start time.");
        
        endTimeInSecondsEpoch = _endTimeInSecondsEpoch; 
        //transfer ether from the renter to the owner (or this wallet)
        //uint256 totalPrice = calculatePriceInWei();

        rentalStage = RentalStage.Available;


        emit RentalPeriodEnded(startTimeInSecondsEpoch, endTimeInSecondsEpoch, priceInWei, perUnit, address(this), renter); 
    }


    function setIsRented(bool _isRented) public onlyOwner { 
        isRented = _isRented;
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

}