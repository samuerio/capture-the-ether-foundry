// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceSend {
    constructor(address addr) payable {
        selfdestruct(payable(addr));
    }
}

