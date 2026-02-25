// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IOrakl} from "./interfaces/IOrakl.sol";

contract Orakl {
    IOrakl public orakl;

    constructor(address _orakl) {
        orakl = IOrakl(_orakl);
    }

    function latestRoundData() public view returns (uint80, int256, uint256) {
        return orakl.latestRoundData();
    }

    function decimals() public view returns (uint8) {
        return orakl.decimals();
    }
}
