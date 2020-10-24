
  
pragma solidity ^0.5.0;


/* In this simple example, there are two partners. 
The contract will first receive funds. 
Funds received are added to the partners respective capital accounts. 
However, Partner 1 has a priority claim on the first cashflows, 
    so Partner1 will sweep all funds until Partner1's hurdle has been met
    after that, funds will be split between Partner1 and Partner2
    
For simplicity, partners are only allowed to withdraw their whole capital account balance.

*/

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/math/SafeMath.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol";
// Note: I ran into version issues with Solidity - I was not able to import both libraries. 
// Remix wanted pragma solicity ^0.5 for SafeMath and something else for Math. 

contract FlippingPartnershipWithPriorityDistribution {
address owner;


//initialize variables with non-zero balances
uint256 Partner1PriorityDistributionAmt = 3*(10**18);  //ie 3 ether
uint256 Partner1PreFlipShare = 75;
uint256 Partner2PreFlipShare = 25;
uint256 Partner1PostFlipShare = 25;
uint256 Partner2PostFlipShare = 75;
uint256 units = 100;


//initialize variables with zero balances
uint256 Partner1PriorityAddition = 0;
uint256 Partner1ProRataAddition = 0;
uint256 Partner2ProRataAddition = 0;
uint256 Partner1CumulAdditions = 0;
uint256 Partner1CapitalAccount = 0;
uint256 Partner2CapitalAccount = 0;
uint256 CumulativeReceivedBalance = 0;
uint256 CumulativePaidOutBalance = 0;
uint256 AmtReceived = 0; 

address payable  Partner1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
address payable  Partner2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    constructor() public{
        owner = msg.sender;
    }

    //This contract will receive payments from anyone
    function a_receivePmts() payable external {
        AmtReceived = msg.value;
        CumulativeReceivedBalance += AmtReceived;

        Partner1PriorityAddition = max(0,min(
            SafeMath.div(SafeMath.mul(AmtReceived, Partner1PreFlipShare),units), 
            SafeMath.sub(Partner1PriorityDistributionAmt, Partner1CumulAdditions)
            )
        );
//        Partner1PriorityAddition = max(0,min(AmtReceived*Partner1PreFlipShare/units, Partner1PriorityDistributionAmt-Partner1CumulAdditions));
        Partner1CumulAdditions += Partner1PriorityAddition;
        Partner1ProRataAddition = (AmtReceived*Partner1PreFlipShare/units - Partner1PriorityAddition) * Partner1PostFlipShare / units;
        Partner2ProRataAddition = AmtReceived - Partner1ProRataAddition - Partner1PriorityAddition;
        
        Partner1CapitalAccount += (Partner1PriorityAddition+Partner1ProRataAddition);
        Partner2CapitalAccount += Partner2ProRataAddition;
    }


    //This pays out all partners
    function b_makeDistributions() payable public {
        distrib2P1() ;
        distrib2P2() ;
    }


    //This makes distributions to Partner 1
    function distrib2P1() payable public {
        CumulativePaidOutBalance += Partner1CapitalAccount;
        Partner1.transfer(Partner1CapitalAccount);  
        Partner1CapitalAccount = 0;
    }

    //This makes distributions to Partner 2
    function distrib2P2() payable public {
        CumulativePaidOutBalance +=   Partner2CapitalAccount;
        Partner2.transfer(Partner2CapitalAccount);  
        Partner2CapitalAccount = 0;
    }



    function showContractMetrics() external view returns (string memory, string memory, string memory) {
        return (
            string(abi.encodePacked("Contract balance:      ",uint2str(address(this).balance))), 
            string(abi.encodePacked("CumulReceivedBal:      ",uint2str(CumulativeReceivedBalance))),
            string(abi.encodePacked("CumulPaidOutBal:       ",uint2str(CumulativePaidOutBalance)))
            );
    } 
    
    function showPartnerMetrics() external view returns (string memory, string memory, string memory, string memory, string memory) {
        return (
            string(abi.encodePacked("Ptnr1PriorityAdd:      ",uint2str(Partner1PriorityAddition))),
            string(abi.encodePacked("Ptnr1ProRataAdd:       ",uint2str(Partner1ProRataAddition))),
            string(abi.encodePacked("Ptnr2ProRataAdd:       ",uint2str(Partner2ProRataAddition))),
            string(abi.encodePacked("Ptnr1CapitalAcct:      ",uint2str(Partner1CapitalAccount))),
            string(abi.encodePacked("Ptnr2CapitalAcct:      ",uint2str(Partner2CapitalAccount)))
            );
    } 


    
    
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//  Add Ins
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------


     //Returns the largest of two numbers.
        function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    //Returns the smallest of two numbers.
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

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
    function whoami () public view returns (address){return msg.sender;}

}  
