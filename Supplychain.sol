pragma solidity ^0.8.0;

contract SupplyChain {
    address owner;
    uint public skuCount;
    mapping (uint => Item) public items;

    enum State { ForSale, Sold, Shipped, Received }

    struct Item {
        string name;
        uint sku;
        uint price;
        State state;
        address payable seller;
        address payable buyer;
    }

    event ForSale(uint sku);
    event Sold(uint sku);
    event Shipped(uint sku);
    event Received(uint sku);

    constructor() {
        owner = msg.sender;
        skuCount = 0;
    }

    function addItem(string memory _name, uint _price) public {
        items[skuCount] = Item({
            name: _name,
            sku: skuCount,
            price: _price,
            state: State.ForSale,
            seller: payable(msg.sender),
            buyer: payable(address(0))
        });
        emit ForSale(skuCount);
        skuCount = skuCount + 1;
    }

    function buyItem(uint sku) public payable {
        Item storage item = items[sku];
        require(item.state == State.ForSale);
        require(msg.value >= item.price);
        item.buyer = payable(msg.sender);
        item.state = State.Sold;
        item.seller.transfer(msg.value);
        emit Sold(sku);
    }

    function shipItem(uint sku) public {
        Item storage item = items[sku];
        require(item.state == State.Sold);
        require(item.seller == msg.sender);
        item.state = State.Shipped;
        emit Shipped(sku);
    }

    function receiveItem(uint sku) public {
        Item storage item = items[sku];
        require(item.state == State.Shipped);
        require(item.buyer == msg.sender);
        item.state = State.Received;
        emit Received(sku);
    }
}
