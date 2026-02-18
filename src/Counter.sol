// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number; // n >= 0 // size => 256, 128, 64, 32, 16, 8

    int256 public number2; // n >= -2^256 and n <= 2^256 - 1

    mapping(address => uint256) public numbers;

    uint256[] public numbersArray;

    address public owner;

    bytes32 public name; // bytes => 32 bytes

    struct Person {
        string name;
        uint256 age;
        bool isStudent;
    }

    Person public person;

    enum Status {
        Pending,
        Completed,
        Failed
    }

    Status public status;

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment() public {
        number++;
    }

    function _onlyOwner() internal view {
        require(msg.sender == owner, "You are not the owner");
    }
}

// (uint256, string, uitn256, address) = bytes32;

// maksimal memori around 24 KB
