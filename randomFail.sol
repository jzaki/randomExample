pragma solidity ^0.4.21;


contract RandomFail {

    address private host;
    address[] public players;
    uint constant public TICKET_PRICE = 0.01 ether;

    function RandomFail() public {
        host = msg.sender;
    }
    
    modifier onlyHost() {
        require(msg.sender == host);
        _;
    }

    function () public payable {
        require(msg.value == 0);
    }

    function purchaseTicket() public payable returns (address[]) {
        require(msg.value > TICKET_PRICE);
        uint256 refund = msg.value - TICKET_PRICE;
        if (refund > 0) {
            msg.sender.transfer(refund);
        }
        players.push(msg.sender);
        return players;
    }
    
    function determineWinnerTime_NO() public onlyHost returns (address winner) {
        uint random = uint(keccak256(now));
        uint winnerIndex = random % players.length;
        winner = players[winnerIndex];
        players.length = 0;
        winner.transfer(address(this).balance);
    }

    function determineWinnerHash_NO() public onlyHost returns (address winner) {
        bytes32 previousBlockHash = block.blockhash(block.number-1);
        uint random = uint(keccak256(previousBlockHash));
        uint winnerIndex = random % players.length;
        winner = players[winnerIndex];
        players.length = 0;
        winner.transfer(address(this).balance);
    }

    function determineWinnerSeedHash_NO(uint randomSeed) public onlyHost returns (address winner) {
        bytes32 previousBlockHash = block.blockhash(block.number-1);
        uint random = uint(keccak256(randomSeed + uint(previousBlockHash)));
        uint winnerIndex = random % players.length;
        winner = players[winnerIndex];
        players.length = 0;
        winner.transfer(address(this).balance);
    }
    
}
