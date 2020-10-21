pragma solidity >=0.4.22 <0.6.0;

// This is a simple example of using a single function to pay two parties

contract Pay2Parties {
uint256 num1;
address owner;
address payable receiver1; 
address payable receiver2; 

    constructor() public{
        owner = msg.sender;
    }
    function setReceiver1 (address payable _receiver1) public {
        receiver1 = _receiver1;
    }
    function setReceiver2 (address payable _receiver2) public {
        receiver2 = _receiver2;
    }

   function getReceiver1() public view returns (address){
        return receiver1;
    }
   function getReceiver2() public view returns (address){
        return receiver2;
    }

   function whoami () public view returns (address){
        return msg.sender;
    }
    function sendBal() payable external {
        uint256 amount1 = msg.value/3;
        uint256 amount2 = msg.value - amount1;
        Principal.transfer(amount1);  
        Interest.transfer(amount2);  
    }

}
