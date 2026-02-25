// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Chainlink} from "@src/week2/Chainlink.sol";

// RUN
// forge test --match-contract ChainlinkTest
contract ChainlinkTest is Test {
    Chainlink public chainlink;
    Chainlink public chainlinkBTC;
    Chainlink public chainlinkETH;

    address public constant BTC_USD = 0x0FB99723Aee6f420beAD13e6bBB79b7E6F034298;
    address public constant ETH_USD = 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1;

    uint8 public constant BTC_DECIMALS = 8;
    uint8 public constant ETH_DECIMALS = 18;

    function setUp() public {
        vm.createSelectFork("base_testnet");
        chainlink = new Chainlink(BTC_USD);
        chainlinkBTC = new Chainlink(BTC_USD);
        chainlinkETH = new Chainlink(ETH_USD);
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testLatestRoundData -vvv
    function testLatestRoundData() public view {
        (, int256 price,,,) = chainlink.latestRoundData();
        uint8 decimals = chainlink.decimals();

        // NON DECIMALS
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log(uint256(price) / (10 ** uint256(decimals)));
        // DECIMALS
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log(uint256(price));
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testDecimals -vvv
    function testDecimals() public view {
        uint8 decimals = chainlink.decimals();
        console.log(decimals);
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testEthToBtcCalculator -vvv
    function testEthToBtcCalculator() public view {
        (, int256 priceBtc,,,) = chainlinkBTC.latestRoundData();
        (, int256 priceEth,,,) = chainlinkETH.latestRoundData();

        // forge-lint: disable-next-line(unsafe-typecast)
        uint256 result = uint256(priceBtc) * 10 ** uint256(ETH_DECIMALS) / uint256(priceEth);
        console.log(result);
    }

    // RUN
    // forge test --match-contract ChainlinkTest --match-test testBtcToEthCalculator -vvv
    function testBtcToEthCalculator() public view {
        (, int256 priceBtc,,,) = chainlinkBTC.latestRoundData();
        (, int256 priceEth,,,) = chainlinkETH.latestRoundData();

        // forge-lint: disable-next-line(unsafe-typecast)
        uint256 result = uint256(priceEth) * 10 ** uint256(BTC_DECIMALS) / uint256(priceBtc);
        console.log(result);
    }
}
