// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20Mock} from "../lib/yield-utils-v2/src/mocks/ERC20Mock.sol";

contract ETHWrapper is ERC20Mock {
    event Wrap(address indexed from, uint amount);
    event Unwrap(address indexed from, uint amount);

    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20Mock(tokenName, tokenSymbol) {}

    receive() external payable {
        mint(msg.sender, msg.value);
        emit Wrap(msg.sender, msg.value);
    }

    function unwrap(uint amount) public {
        burn(msg.sender, amount);

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Unwrapping failed!");
        emit Unwrap(msg.sender, amount);
    }
}
