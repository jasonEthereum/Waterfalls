pragma solidity >=0.4.22 <0.6.0;

// In this simple example, one third of funds received by the contract will be forwarded to a specific 
// account for the repayment of principal.  The remainder will be used to repay interest

contract PayPrincipalAndInterest {
address owner;
uint256 PercentPrincipal = 33;
uint256 units = 100;

address payable public Principal = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
address payable public Interest = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    constructor() public{
        owner = msg.sender;
    }
    function sendBal() payable external {
        uint256 PrincipalAmount = msg.value / units * PercentPrincipal;
        uint256 InterestAmount = msg.value - PrincipalAmount;
        Principal.transfer(PrincipalAmount);  
        Interest.transfer(InterestAmount);  
    }

}
