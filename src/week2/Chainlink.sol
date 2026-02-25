// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IChainlink} from "./interfaces/IChainlink.sol";

contract Chainlink {
    IChainlink public priceFeed;

    constructor(address _priceFeed) {
        priceFeed = IChainlink(_priceFeed);
    }

    function latestRoundData() public view returns (uint80, int256, uint256, uint256, uint80) {
        return priceFeed.latestRoundData();
    }

    function decimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}
