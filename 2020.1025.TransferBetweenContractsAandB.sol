pragma solidity ^0.5.0;

/* This is two contracts:  
This is ContractA which receives Ether and forwards it to ConractB, 
ContractB holds the ether and displays a balance. 

Both Contracts compile cleanly, but I wasn't able to get Ether to transfer from ContractA to ContractB

*/

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";

contract ContractA {
address owner;

//initialize variables with non-zero balances
uint256 CumulAdditions = 0;
uint256 CapitalAccount = 0;

uint256 CumulativeReceivedBalance = 0;
uint256 CumulativePaidOutBalance = 0;
uint256 AmtReceived = 0; 

address payable  ContractB = 0x3Ef35c56Ae041539d5bA8C7d22322cED3c0a5544;

    constructor() public{
        owner = msg.sender;
    }

    //This contract will receive payments from anyone
    function a_receivePmts() payable external {
        AmtReceived = msg.value;
        CumulativeReceivedBalance += AmtReceived;
        CapitalAccount += AmtReceived;
    }


    //This does the payouts
    function b_makeDistributions() payable public {
        CumulativePaidOutBalance += CapitalAccount;
        ContractB.transfer(CapitalAccount/2);  
        CapitalAccount = 0;
    }

    function showContractMetrics() external view returns (string memory, string memory, string memory) {
        return (
            string(abi.encodePacked("Contract balance:      ",uint2str(address(this).balance))), 
            string(abi.encodePacked("CumulReceivedBal:      ",uint2str(CumulativeReceivedBalance))),
            string(abi.encodePacked("CumulPaidOutBal:       ",uint2str(CumulativePaidOutBalance)))
            );
    } 
    
    function showPartnerMetrics() external view returns (string  memory) {
        return (
            string(abi.encodePacked("CapitalAcct:      ",uint2str(CapitalAccount)))
            );
    } 

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//  Add Ins
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

    //converts numbers to strings:
     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //just a handy way to get addresses:
    function getSenderAddress () public view returns (address){return msg.sender;}
    function getContractAddress() public view returns (address) {return address(this);}


}  


pragma solidity ^0.5.0;


/* This is the second of two contracts:  
ContractA receives Ether and forwards it to ConractB, 
This is ContractB, which holds the ether and displays a balance. 
*/

contract ContractB {
address owner;

//initialize variables with non-zero balances
uint256 CumulAdditions = 0;
uint256 CapitalAccount = 0;

uint256 CumulativeReceivedBalance = 0;
uint256 CumulativePaidOutBalance = 0;
uint256 AmtReceived = 0; 

    constructor() public{
        owner = msg.sender;
    }

    //This contract will receive payments from anyone
    function a_receivePmts() payable external {
        AmtReceived = msg.value;
        CumulativeReceivedBalance += AmtReceived;
        CapitalAccount += AmtReceived;
    }

    function showContractMetrics() external view returns (string memory, string memory, string memory) {
        return (
            string(abi.encodePacked("Contract balance:      ",uint2str(address(this).balance))), 
            string(abi.encodePacked("CumulReceivedBal:      ",uint2str(CumulativeReceivedBalance))),
            string(abi.encodePacked("CumulPaidOutBal:       ",uint2str(CumulativePaidOutBalance)))
            );
    } 
    
    function showPartnerMetrics() external view returns (string  memory) {
        return (
            string(abi.encodePacked("CapitalAcct:      ",uint2str(CapitalAccount)))
            );
    } 

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//  Add Ins
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

    //converts numbers to strings:
     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //just a handy way to get addresses:
    function getSenderAddress () public view returns (address){return msg.sender;}
    function getContractAddress() public view returns (address) {return address(this);}
}  


