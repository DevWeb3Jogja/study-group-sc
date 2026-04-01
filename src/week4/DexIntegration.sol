// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IDex} from "./interfaces/IDex.sol";

contract DexIntegration {
    using SafeERC20 for IERC20;

    // uniswap router address optimism mainnet
    address public constant UNISWAP_V3_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    function swap(IDex.ExactInputSingleParams calldata params) public returns (uint256 amountOut) {
        IERC20(params.tokenIn).safeTransferFrom(msg.sender, address(this), params.amountIn);
        IERC20(params.tokenIn).approve(UNISWAP_V3_ROUTER, params.amountIn);
        amountOut = IDex(UNISWAP_V3_ROUTER).exactInputSingle(params);
    }
}
