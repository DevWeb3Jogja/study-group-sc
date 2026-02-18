// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Week1_1} from "@src/week1/Week1_1.sol";

// RUN
// forge test
// forge test --match-contract Week1_1Test
// forge test --match-contract Week1_1Test --match-test testSetNumber

contract Week1_1Test is Test {
    Week1_1 public week11;

    function setUp() public {
        week11 = new Week1_1();
    }

    // RUN
    // forge test --match-contract Week1_1Test --match-test testSetNumber -vvv
    function testSetNumber() public {
        week11.setNumber(1);
        assertEq(week11.number(), 1);
    }

    // RUN
    // forge test --match-contract Week1_1Test --match-test testIncrement -vvv
    function testIncrement() public {
        week11.increment();
        assertEq(week11.number(), 1);
    }

    // RUN
    // forge test --match-contract Week1_1Test --match-test testDecrement -vvv
    function testDecrement() public {
        testIncrement();
        week11.decrement();
        assertEq(week11.number(), 0);
    }

    // RUN
    // forge test --match-contract Week1_1Test --match-test testGetNumber -vvv
    function testGetNumber() public view {
        assertEq(week11.getNumber(), 0);
    }
}
