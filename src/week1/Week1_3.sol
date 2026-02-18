// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_3 {
    error UserExist();

    struct User {
        uint256 id;
        string name;
        bool isStudent;
    }

    User[] public users;

    mapping(address => User) public user;
    // address => uint256

    modifier userExist() {
        _userExist();
        _;
    }

    function addUser(string calldata name, bool isStudent) public userExist {
        // array
        users.push(User({id: users.length + 1, name: name, isStudent: isStudent}));

        // mapping
        user[msg.sender] = User({id: users.length, name: name, isStudent: isStudent});
    }

    function editUser(string calldata name, bool isStudent) public {
        user[msg.sender] = User({id: user[msg.sender].id, name: name, isStudent: isStudent});
    }

    function _userExist() internal view {
        if (user[msg.sender].id != 0) revert UserExist();
    }

    function getLengthUsers() public view returns (uint256) {
        return users.length;
    }
}
