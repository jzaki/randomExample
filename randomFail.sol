pragma solidity ^0.4.21;


contract RandomFail {

    address[] public players;
    uint constant public TICKET_PRICE = 0.01 ether;

    function RandomFail() public {

    }

    function () public payable {
        require(msg.value == 0);
    }

    function purchaseTicket() public payable {

    }

}
