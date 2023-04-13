pragma solidity ^0.5.0;

contract TokenExchange {
    address public token1;
    address public token2;
    uint public rate;

    constructor(address _token1, address _token2, uint _rate) public {
        token1 = _token1;
        token2 = _token2;
        rate = _rate;
    }

    function exchange(uint amount) public {
        require(Token(token1).transferFrom(msg.sender, address(this), amount));
        require(Token(token2).transfer(msg.sender, amount * rate));
    }
}

interface Token {
    function transfer(address recipient, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
}
