pragma solidity ^0.5.0;

contract Lottery {
    address payable[] public players;
    uint public maxPlayers;
    uint public lotteryEndTime;
    bool public lotteryEnded;

    constructor(uint _maxPlayers, uint _lotteryDuration) public {
        maxPlayers = _maxPlayers;
        lotteryEndTime = now + _lotteryDuration;
        lotteryEnded = false;
    }

    function enter() public payable {
        require(!lotteryEnded, "Lottery has already ended.");
        require(now <= lotteryEndTime, "Lottery has expired.");
        require(players.length < maxPlayers, "Maximum number of players reached.");
        players.push(msg.sender);
    }

    function pickWinner() public {
        require(!lotteryEnded, "Lottery has already ended.");
        require(now > lotteryEndTime || players.length == maxPlayers, "Lottery is still ongoing.");
        uint index = random() % players.length;
        players[index].transfer(address(this).balance);
        lotteryEnded = true;
    }

    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }
}
