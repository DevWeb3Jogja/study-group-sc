// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_2 {
    event SetBytesByString(string _encode);
    event SetBytesByBytes(bytes _encode);

    error NotOwner();
    error ContractIsPaused();

    bytes public encode;

    address public owner;

    enum IsPaused {
        Paused,
        Unpaused
    }

    IsPaused public isPaused;

    modifier whenPaused() {
        _whenPaused();
        _;
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setBytesByString(string calldata _encode) public whenPaused {
        encode = abi.encode(_encode);
        emit SetBytesByString(_encode);
    }

    function setBytesByBytes(bytes calldata _encode) public whenPaused {
        encode = _encode;
        emit SetBytesByBytes(_encode);
    }

    function decodeBytesToString() public view whenPaused returns (string memory) {
        return abi.decode(encode, (string));
    }

    function pause() public onlyOwner {
        isPaused = IsPaused.Paused;
    }

    function unpause() public onlyOwner {
        isPaused = IsPaused.Unpaused;
    }

    function _whenPaused() internal view {
        if (isPaused == IsPaused.Paused) revert ContractIsPaused();
    }

    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }
}
