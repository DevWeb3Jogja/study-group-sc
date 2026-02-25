// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Redstone} from "src/week2/Redstone.sol";
import "forge-std/console.sol";

contract RedstoneTest is Test {
    Redstone public redstone;

    address public constant BTC_USD = 0x3587a73AA02519335A8a6053a97657BECe0bC2Cc;
    address public constant ETH_USD = 0x4BAD96DD1C7D541270a0C92e1D4e5f12EEEA7a57;

    uint8 public constant BTC_DECIMALS = 8;
    uint8 public constant ETH_DECIMALS = 18;

    Redstone public redstoneBTC;
    Redstone public redstoneETH;

    function setUp() public {
        vm.createSelectFork("hyperevm_testnet");
        redstoneBTC = new Redstone(BTC_USD);
        redstoneETH = new Redstone(ETH_USD);
    }

    // forge test --match-contract RedstoneTest --match-test testLatestRoundData -vvv
    function testLatestRoundData() public view {
        (, int256 priceBTC,,,) = redstoneBTC.latestRoundData();
        (, int256 priceETH,,,) = redstoneETH.latestRoundData();
        // console.log("Price", price / 1e8);
        uint8 decimalsBTC = redstoneBTC.decimals();
        uint8 decimalsETH = redstoneETH.decimals();

        // PRICE BTC
        // console.log("Price BTC/USD", uint256(priceBTC) / (10 ** uint256(decimalsBTC)));
        console.log("Price BTC/USD", uint256(priceBTC));

        // PRICE ETH
        // console.log("Price ETH/USD", uint256(priceETH) / (10 ** uint256(decimalsETH)) );
        console.log("Price ETH/USD", uint256(priceETH));

        // PRICE BTC/ETH
        console.log("Price BTC/ETH", uint256(priceBTC) / uint256(priceETH));

        // Conversion BTC/ETH
        console.log("Price BTC/ETH", (uint256(priceBTC) * 10 ** uint256(decimalsETH)) / uint256(priceETH));

        // Conversion ETH/BTC
        console.log("Price ETH/BTC", (uint256(priceETH) * 10 ** uint256(decimalsBTC)) / uint256(priceBTC));
    }

    // forge test --match-contract RedstoneTest --match-test testDecimals -vvv
    function testDecimals() public view {
        uint8 decimals = redstone.decimals();
        assertEq(decimals, BTC_DECIMALS);
        console.log("Decimals", decimals);
    }
}
