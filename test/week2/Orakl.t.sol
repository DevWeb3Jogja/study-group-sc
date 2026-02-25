// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Orakl} from "@src/week2/Orakl.sol";

contract OraklTest is Test {
    Orakl public orakl;

    address public constant BTC_USDT = 0x43aDD670A0E1948C90386d2b972FCAEC6CE1BE90;
    address public constant ETH_USDT = 0x22BE5ff1eF09ebf06995Da9050d44d23070C2142;

    bytes32 public test = 0xf9c0172ba10dfa4d19088d94f5bf61d3b54d5bd7483a322a982e1373ee8ea31b;

    function setUp() public {
        vm.createSelectFork("kairos_testnet");
        orakl = new Orakl(BTC_USDT);
    }

    // RUN
    // forge test --match-contract OraklTest --match-test testLatestRoundData -vvv
    function testLatestRoundData() public view {
        (, int256 price,) = orakl.latestRoundData();
        uint8 decimals = orakl.decimals();
        // DECIMALS
        console.log(uint256(price) / (10 ** uint256(decimals)));
        // NON DECIMALS
        console.log(uint256(price));
    }
}
