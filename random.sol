pragma solidity ^0.4.21;


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
    
    event Winner(address winner);
    
    function determineWinner(bytes32 _randomSeedHash) public onlyHost {
        require(!closed);
        closed = true;
        hashedSeed = _randomSeedHash;
        blockNumberToUse = block.number+1;
    }

    function declareWinner(bytes32 _randomSeed) public onlyHost returns (address winner) {
        require(closed);
        require(hashedSeed == keccak256(_randomSeed));
        hashedSeed = "";
        bytes32 blockHash = block.blockhash(blockNumberToUse);
        uint random = uint(keccak256(uint(_randomSeed) + uint(blockHash)));
        uint winnerIndex = random % players.length;
        winner = players[winnerIndex];
        players.length = 0;
        closed = false;
        emit Winner(winner);
        winner.transfer(address(this).balance);
    }
}
