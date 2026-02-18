// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Week1_3} from "@src/week1/Week1_3.sol";

// RUN
// forge test
// forge test --match-contract Week1_3Test
// forge test --match-contract Week1_3Test --match-test testAddUser
contract Week1_3Test is Test {
    Week1_3 public week13;

    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");

    function setUp() public {
        vm.startPrank(owner);
        week13 = new Week1_3();
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract Week1_3Test --match-test testAddUser -vvv
    function testAddUser() public {
        vm.startPrank(owner);
        week13.addUser("Alice", true);
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract Week1_3Test --match-test testEditUser -vvv
    function testEditUser() public {
        vm.startPrank(owner);
        week13.addUser("owner", true);
        week13.editUser("owner", false);
        vm.stopPrank();

        vm.startPrank(alice);
        week13.addUser("Alice", true);
        vm.stopPrank();

        console.log(week13.getLengthUsers());
    }
}
