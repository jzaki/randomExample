contract Random {

    address private host;
    address[] public players;
    uint constant public TICKET_PRICE = 0.01 ether;
    bool public closed = false;
    bytes32 public hashedSeed;
    uint public blockNumberToUse;

    function Random() public {
        host = msg.sender;
        players.push(host);
    }
    
    modifier onlyHost() {
        require(msg.sender == host);
        _;
    }

    function () public payable {
        require(msg.value == 0);
    }

    function purchaseTicket() public payable returns (address[]) {
        require(closed == false);
        require(msg.value > TICKET_PRICE);
        uint256 refund = msg.value - TICKET_PRICE;
        if (refund > 0) {
            msg.sender.transfer(refund);
        }
        players.push(msg.sender);
        return players;
    }
}
