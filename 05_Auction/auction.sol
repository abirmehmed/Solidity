//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction {
    address payable public beneficiary;
    uint public auctionEndTime;
    bool public ended;

    address public highestBidder;
    uint public highestBid;

    mapping(address => uint) public pendingReturns;

    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    constructor(uint _biddingTime, address payable _beneficiary) {
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + _biddingTime;
    }

    function bid() public payable {
        require(block.timestamp <= auctionEndTime, "Auction already ended.");
        require(msg.value > highestBid, "There already is a higher bid.");

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            (bool success,) = msg.sender.call{value: amount}("");
            if (!success) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public {
        require(block.timestamp >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        beneficiary.transfer(highestBid);
    }
}