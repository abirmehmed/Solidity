pragma solidity ^0.5.0;

contract CropInsurance {
    address payable public insurer;
    uint public premium;
    uint public coverageAmount;
    bool public policyActive;
    uint public policyEndDate;

    event PolicyPurchased(address farmer, uint premium);
    event PolicyClaimed(address farmer, uint coverageAmount);

    constructor(uint _premium, uint _coverageAmount) public {
        insurer = msg.sender;
        premium = _premium;
        coverageAmount = _coverageAmount;
        policyActive = false;
    }

    function purchasePolicy() public payable {
        require(msg.value == premium, "Incorrect premium amount.");
        require(!policyActive, "Policy already active.");
        policyActive = true;
        policyEndDate = now + 365 days;
        emit PolicyPurchased(msg.sender, msg.value);
    }

    function claimPolicy() public {
        require(policyActive, "No active policy.");
        require(now <= policyEndDate, "Policy expired.");
        msg.sender.transfer(coverageAmount);
        policyActive = false;
        emit PolicyClaimed(msg.sender, coverageAmount);
    }

    function cancelPolicy() public {
        require(policyActive, "No active policy.");
        require(now <= policyEndDate, "Policy expired.");
        msg.sender.transfer(premium / 2);
        policyActive = false;
    }
}
