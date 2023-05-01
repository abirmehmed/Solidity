//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery {
    address payable[] players;
    uint public maxPlayers;
    uint public lotteryEndTime;
    bool public lotteryEnded;

    constructor(uint _maxPlayers, uint _lotteryDuration) {
        maxPlayers = _maxPlayers;
        lotteryEndTime = block.timestamp + _lotteryDuration;
        lotteryEnded = false;
    }

    function enter() public payable {
        require(!lotteryEnded, "Lottery has already ended.");
        require(block.timestamp <= lotteryEndTime, "Lottery has expired.");
        require(players.length < maxPlayers, "Maximum number of players reached.");
        players.push(payable(msg.sender));
    }

    function pickWinner() public {
        require(!lotteryEnded, "Lottery has already ended.");
        require(block.timestamp > lotteryEndTime || players.length == maxPlayers, "Lottery is still ongoing.");
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        lotteryEnded = true;
    }

    function reset() public {
        require(lotteryEnded, "Lottery has not ended.");
        lotteryEnded = false;
        delete players;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));
    }
}
