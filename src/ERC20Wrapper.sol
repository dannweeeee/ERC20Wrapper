// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {ERC20Mock} from "../lib/yield-utils-v2/src/mocks/ERC20Mock.sol";
import {IERC20} from "../lib/yield-utils-v2/src/token/IERC20.sol";

contract ERC20Wrapper is ERC20Mock {
    //STATE VARS
    IERC20 public immutable token;

    //events
    event Wrap(address indexed from, uint amount);
    event Unwrap(address indexed from, uint amount);

    //constructor function
    constructor(
        IERC20 token_,
        string memory tokenName,
        string memory tokenSymbol
    ) ERC20Mock(tokenName, tokenSymbol) {
        token = token_;
    }

    //wrap function
    function wrap(uint amount) public {
        _mint(msg.sender, amount);

        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Wrapping failed!");

        emit Wrap(msg.sender, amount);
    }

    //unwrap function
    function unwrap(uint amount) public {
        _burn(msg.sender, amount);

        bool success = token.transfer(msg.sender, amount);
        require(success, "Unwrapping failed!");

        emit Unwrap(msg.sender, amount);
    }
}
