// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Week1_2} from "@src/week1/Week1_2.sol";

// RUN
// forge test
// forge test --match-contract Week1_2Test
// forge test --match-contract Week1_2Test --match-test testSetBytesByString

contract Week1_2Test is Test {
    Week1_2 public week12;

    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");

    function setUp() public {
        vm.startPrank(owner);
        week12 = new Week1_2();
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract Week1_2Test --match-test testSetBytesByString -vvv
    function testSetBytesByString() public {
        week12.setBytesByString("Hello");
        assertEq(week12.encode(), abi.encode("Hello"));
    }

    // RUN
    // forge test --match-contract Week1_2Test --match-test testSetBytesByBytes -vvv
    function testSetBytesByBytes() public {
        bytes memory encode = abi.encode("Hello");
        week12.setBytesByBytes(encode);
        assertEq(week12.decodeBytesToString(), "Hello");
    }

    // RUN
    // forge test --match-contract Week1_2Test --match-test testDecodeBytesToString -vvv
    function testDecodeBytesToString() public view {
        assertEq(week12.decodeBytesToString(), "Hello");
    }

    // RUN
    // forge test --match-contract Week1_2Test --match-test testPause -vvv
    function testPause() public {
        vm.startPrank(owner);
        week12.pause();
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract Week1_2Test --match-test testSetBytesByStringWhenPaused -vvv
    function testSetBytesByStringWhenPaused() public {
        vm.startPrank(owner);
        week12.pause();
        vm.stopPrank();

        vm.startPrank(owner);
        week12.setBytesByString("Hello");
        vm.stopPrank();
    }
}
