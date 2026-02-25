// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

interface IChainlink {
    function latestRoundData() external view returns (uint80, int256, uint256, uint256, uint80);
    function decimals() external view returns (uint8);
}
