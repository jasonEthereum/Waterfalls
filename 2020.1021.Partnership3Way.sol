pragma solidity >=0.4.22 <0.6.0;

/* In this simple example, there are three 3 partners. 
Partner1 gets a 10% royalty off the top
Partner 2 and Partner 3 share the remainder
*/


contract Partnership3Way {
address owner;
uint256 RoyaltyRate = 10;
uint256 Partner2ShareOfRemainder = 40;
uint256 Partner3ShareOfRemainder = 60;
uint256 units = 100;

address payable  Partner1 = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;
address payable  Partner2 = 0x617F2E2fD72FD9D5503197092aC168c91465E7f2;
address payable  Partner3 = 0x17F6AD8Ef982297579C203069C1DbfFE4348c372;

    constructor() public{
        owner = msg.sender;
    }
    function whoami () public view returns (address){
        //this function is not necessary - only useful for getting addresses in remix for testing
        return msg.sender;
    }

    function sendBal() payable external {
        uint256 Partner1Amt = msg.value / units * RoyaltyRate;
        uint256 Partner2Amt = (msg.value - Partner1Amt)/units * Partner2ShareOfRemainder;
        uint256 Partner3Amt = (msg.value - Partner1Amt)/units * Partner3ShareOfRemainder;
        Partner1.transfer(Partner1Amt);  
        Partner2.transfer(Partner2Amt);  
        Partner3.transfer(Partner3Amt);  
    }

}
