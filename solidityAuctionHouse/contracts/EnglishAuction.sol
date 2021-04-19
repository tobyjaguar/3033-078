/// CISI-GA.3033-078
/// Cryptocurrency and Decentralized Ledgers
/// Spring 2021
/// Project 2, Auctions
/// Authored by Alex Lee and Toby Algya
pragma solidity ^0.5.16;

import "./Auction.sol";

contract EnglishAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod;
    uint public minimumPriceIncrement;

    // TODO: place your code here
    uint256 public currentHighestBid;
    uint256 public biddingWindow;
    address public currentWinner;
    mapping (address=>uint256) public bids;

    // constructor
    constructor(
      address _sellerAddress,
      address _judgeAddress,
      address _timerAddress,
      uint _initialPrice,
      uint _biddingPeriod,
      uint _minimumPriceIncrement
    )
      public
      Auction (_sellerAddress, _judgeAddress, _timerAddress)
    {

        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        minimumPriceIncrement = _minimumPriceIncrement;

        // TODO: place your code here
        currentHighestBid = initialPrice;
        biddingWindow = time() + biddingPeriod;
    }

    function bid()
      public
      payable
    {
        require(time() < biddingWindow, "Auction is closed");
        if(currentWinner == address(0))
          require(currentHighestBid <= msg.value, "Bid must be higher than current highest bid");
        else
        {
          require((currentHighestBid + minimumPriceIncrement) <= msg.value, "Bid must be higher than current highest bid plus increment");
          uint256 refund = bids[currentWinner];
          bids[currentWinner] = 0;
          balances[currentWinner] += refund;
        }
        currentWinner = msg.sender;
        biddingWindow = (time() + biddingPeriod);
        currentHighestBid = msg.value;
        bids[msg.sender] += msg.value;
        winningPrice = currentHighestBid;
    }

    // Need to override the default implementation
    function getWinner()
      public
      view
      returns (address winner)
    {
        if(biddingWindow <= time())
          winner = currentWinner;
        return winner;
    }
}
