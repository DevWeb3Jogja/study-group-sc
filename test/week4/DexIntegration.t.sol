// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {DexIntegration} from "@src/week4/DexIntegration.sol";
import {IDex} from "@src/week4/interfaces/IDex.sol";
import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";

contract DexIntegrationTest is Test {
    DexIntegration public dexIntegration;

    // WETH optimism mainnet
    address public constant WETH = 0x4200000000000000000000000000000000000006; // WETH
    // USDC optimism mainnet
    address public constant USDC = 0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85; // USDC

    address public alice = makeAddr("alice");

    function setUp() public {
        vm.createSelectFork("op_mainnet");
        dexIntegration = new DexIntegration();

        deal(WETH, alice, 10 ether);
        // deal(USDC, alice, 100_000e6);
    }

    // RUN
    // forge test --match-contract DexIntegrationTest --match-test testSwap -vvv
    function testSwap() public {
        vm.startPrank(alice);

        console.log("Alice Balance Before WETH = ", IERC20(WETH).balanceOf(alice));
        console.log("Alice Balance Before USDC = ", IERC20(USDC).balanceOf(alice));

        IDex.ExactInputSingleParams memory params = IDex.ExactInputSingleParams({
            tokenIn: WETH,
            tokenOut: USDC,
            fee: 3000,
            recipient: alice,
            deadline: block.timestamp + 1000,
            amountIn: 1 ether,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        IERC20(WETH).approve(address(dexIntegration), 1 ether);
        uint256 amountOut = amountdexIntegration.swap(params);

        console.log("Alice Balance After USDC = ", IERC20(USDC).balanceOf(alice)); // 2121.235201
        console.log("Alice Balance After WETH = ", IERC20(WETH).balanceOf(alice)); // 9.000000000000000000
    }
}
