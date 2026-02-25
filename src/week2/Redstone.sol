// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "./interfaces/IRedstone.sol";

contract Redstone {
    IRedstone public priceFeed;

    constructor(address _priceFeed) {
        priceFeed = IRedstone(_priceFeed);
    }

    function latestRoundData()
        public
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return priceFeed.latestRoundData();
    }

    function decimals() public view returns (uint8) {
        return priceFeed.decimals();
    }
}
