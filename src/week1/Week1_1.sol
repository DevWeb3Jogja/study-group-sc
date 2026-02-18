// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_1 {
    event SetNumber(address executor, uint256 newNumber);
    event Increment(uint256 newNumber);
    event Decrement(uint256 newNumber);

    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
        emit SetNumber(msg.sender, newNumber);
    }

    function increment() public {
        number++;
        emit Increment(number);
    }

    function decrement() external {
        number--;
        emit Decrement(number);
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
