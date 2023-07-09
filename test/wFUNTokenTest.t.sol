// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";

import "../src/FUNToken.sol";
import "../src/ERC20Wrapper.sol";

abstract contract StateFUNminted is Test {
    
    FUNToken fun;
    ERC20Wrapper wfun;
    address user;
    uint userTokens;

    event Wrap(address indexed from, uint amount);
    event Unwrap(address indexed from, uint amount);

    function setUp() public virtual {
        fun = new FUNToken();
        wfun = new ERC20Wrapper(fun, "Wrapped FUN", "wFUN");

        user = address(1);
        vm.label(user, "user");

        userTokens = 100;
        fun.mint(user, userTokens);
        vm.prank(user);
        fun.approve(address(wfun), userTokens);
    }
}

contract StateFUNmintedTest is StateFUNminted {
    function testWrapRevertsIfTransferFails() public {
        console2.log("Deposit should revert if transfer fails");
        fun.setFailTransfers(true);

        vm.prank(user);
        vm.expectRevert("Wrapping failed!");
        wfun.wrap(userTokens);
    }

    function testWrap() public {
        console2.log("User exchanges half of his FUN tokens for wFUN tokens");
        vm.prank(user);
        vm.expectEmit(true, false, false, true);
        emit Wrap(user, userTokens / 2);
        wfun.wrap(userTokens / 2);
        assertTrue(fun.balanceOf(user) == wfun.balanceOf(user));
    }
}

abstract contract StateFunWrapped is StateFUNminted {
    function setUp() public virtual override {
        super.setUp();

        vm.prank(user);
        wfun.wrap(userTokens / 2);
    }
}

contract StateFUNWrappedTest is StateFunWrapped {
    function testUnwrapRevertsIfTransferFails() public {
        console2.log("Unwrap should revert if transfer fails");
        fun.setFailTransfers(true);
        vm.prank(user);
        vm.expectRevert("Unwrapping failed!");
        wfun.unwrap(userTokens / 2);
    }

    function testCannotUnwrapExcessofWrapped() public {
        console2.log(
            "User should not be able to unwrap more than his quantity of wrapped tokens"
        );
        vm.prank(user);
        vm.expectRevert("ERC20: Insufficient balance");
        wfun.unwrap(userTokens * 2);
    }

    function testUnwrap(uint amount) public {
        console2.log(
            "User should receive FUN tokens, and the corresponding amount of wFUN tokens should be burnt"
        );
        vm.prank(user);
        vm.assume(amount < userTokens / 2);
        vm.assume(amount > 0);

        vm.expectEmit(true, false, false, true);
        emit Unwrap(user, amount);
        wfun.unwrap(amount);

        assertTrue(fun.balanceOf(user) == (userTokens / 2 + amount));
        assertTrue(wfun.balanceOf(user) == (userTokens / 2 - amount));
    }
}
