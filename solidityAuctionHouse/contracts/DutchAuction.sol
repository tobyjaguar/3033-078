/// CISI-GA.3033-078
/// Cryptocurrency and Decentralized Ledgers
/// Spring 2021
/// Project 2, Auctions
/// Authored by ta1749
pragma solidity ^0.5.16;

import "./Auction.sol";

contract DutchAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod;
    uint public offerPriceDecrement;

    // TODO: place your code here
    uint256 public initialTime;
    uint256 public reserve;

    // constructor
    constructor(
      address _sellerAddress,
      address _judgeAddress,
      address _timerAddress,
      uint _initialPrice,
      uint _biddingPeriod,
      uint _offerPriceDecrement
    )
        public
        Auction (_sellerAddress, _judgeAddress, _timerAddress)
    {

        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        offerPriceDecrement = _offerPriceDecrement;

        // TODO: place your code here
        initialTime = time();
        reserve = initialPrice - (biddingPeriod * offerPriceDecrement);
    }


    function bid()
      public
      payable
    {
        require(winnerAddress == address(0), "bidding is closed");
        require(time() < (initialTime + biddingPeriod), "auction has expired");
        uint256 refund = 0;
        uint256 price = initialPrice - ((time() - initialTime) * offerPriceDecrement);
        if(price < reserve)
          price = reserve;
        require(price <= msg.value, "Bid too low");
        winnerAddress = msg.sender;
        refund = msg.value - price;
        winningPrice = price;
        // refund change
        uint256 balanceBefore = balances[msg.sender];
        balances[msg.sender] += refund;
        require(balances[msg.sender] >= balanceBefore, "Refund failed, math error");
    }

}
