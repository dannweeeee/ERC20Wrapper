// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console2} from "../lib/forge-std/src/console2.sol";

import {ETHWrapper} from "../src/ETHWrapper.sol";

abstract contract StateZero is Test {
    ETHWrapper wrapper;
    address user;
    uint userTokens;

    event Wrap(address indexed from, uint amount);
    event Unwrap(address indexed from, uint amount);

    function setUp() public virtual {
        wrapper = new ETHWrapper("Wrapped ETH", "WETH");

        user = address(1);
        vm.label(user, "user");
        vm.deal(user, 1 ether);
    }
}

contract StateZeroTest is StateZero {
    function testReceive() public {
        vm.expectEmit(true, false, false, true);
        emit Wrap(user, 0.5 ether);

        vm.prank(user);
        (bool sent, ) = address(wrapper).call{value: 0.5 ether}("");
        require(sent);

        assertTrue(wrapper.balanceOf(user) == 0.5 ether);
        assertTrue(user.balance == 0.5 ether);
    }
}

abstract contract StateUserWithWrappedETH is StateZero {
    function setUp() public virtual override {
        super.setUp();

        vm.prank(user);
        (bool sent, ) = address(wrapper).call{value: 0.5 ether}("");
        require(sent);
    }
}

contract StateUserWithWrappedETHTest is StateUserWithWrappedETH {
    function testUnwrap(uint amount) public {
        vm.assume(amount <= 0.5 ether);
        vm.assume(amount > 0);

        vm.prank(user);
        vm.expectEmit(true, false, false, true);
        emit Unwrap(user, amount);
        wrapper.unwrap(amount);

        assertTrue(wrapper.balanceOf(user) == 0.5 ether - amount);
        assertTrue(user.balance == 0.5 ether + amount);
    }
}
