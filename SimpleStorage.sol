// SPDX Licence-Identifier : MIT ;
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint storedData;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function set(uint x) public {
        require(msg.sender == owner, "Only the owner can set the value.");
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
