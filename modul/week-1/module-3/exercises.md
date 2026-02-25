# Module 3: Exercises

## Practice Tasks for Modifiers & Access Control

---

## Exercise 3.1: Basic Modifier Creation ⭐

**Difficulty**: Easy  
**Time**: 15 minutes

### Task

Create a contract `AgeRestriction.sol` with:
- A modifier that ensures only users 18+ can call certain functions
- A mapping to store user ages
- A function to register age (anyone can call)
- A function to vote (only 18+ can call)

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract AgeRestriction {
    error UnderAge(uint256 age, uint256 required);
    error NotRegistered();
    
    mapping(address => uint256) public ages;
    
    modifier ageCheck(uint256 minimumAge) {
        _ageCheck(minimumAge);
        _;
    }
    
    function _ageCheck(uint256 minimumAge) internal view {
        if (ages[msg.sender] == 0) revert NotRegistered();
        if (ages[msg.sender] < minimumAge) {
            revert UnderAge(ages[msg.sender], minimumAge);
        }
    }
    
    function registerAge(uint256 _age) public {
        require(ages[msg.sender] == 0, "Already registered");
        ages[msg.sender] = _age;
    }
    
    function vote() public ageCheck(18) {
        // Voting logic here
    }
}
```

</details>

---

## Exercise 3.2: Multi-Sig Wallet Modifier ⭐⭐

**Difficulty**: Medium  
**Time**: 25 minutes

### Task

Create a `MultiSigWallet.sol` contract where:
- Multiple owners can be added
- Certain functions require at least 2 owners to approve
- Use modifiers to implement the approval logic

### Requirements

- Store multiple owner addresses
- Track approvals for transactions
- Create a `withdraw()` function that needs 2 approvals

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract MultiSigWallet {
    error NotOwner();
    error AlreadyApproved();
    error NotEnoughApprovals();
    
    address[] public owners;
    mapping(address => bool) public isOwner;
    mapping(bytes32 => mapping(address => bool)) public approvals;
    
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }
    
    modifier requiresApprovals(uint256 required) {
        _requiresApprovals(required, msg.sender);
        _;
    }
    
    constructor(address[] memory _owners) {
        for (uint256 i = 0; i < _owners.length; i++) {
            owners.push(_owners[i]);
            isOwner[_owners[i]] = true;
        }
    }
    
    function approveTransaction(bytes32 txHash) public onlyOwner {
        if (approvals[txHash][msg.sender]) revert AlreadyApproved();
        approvals[txHash][msg.sender] = true;
    }
    
    function withdraw(uint256 amount, bytes32 txHash) 
        public 
        onlyOwner 
        requiresApprovals(2) 
    {
        require(approvals[txHash][msg.sender], "Not approved");
        payable(msg.sender).transfer(amount);
    }
    
    function _onlyOwner() internal view {
        if (!isOwner[msg.sender]) revert NotOwner();
    }
    
    function _requiresApprovals(uint256 required, address sender) internal view {
        uint256 count = 0;
        for (uint256 i = 0; i < owners.length; i++) {
            if (approvals[keccak256(abi.encodePacked(sender))][owners[i]]) {
                count++;
            }
        }
        if (count < required) revert NotEnoughApprovals();
    }
}
```

</details>

---

## Exercise 3.3: Time-Lock Modifier ⭐⭐

**Difficulty**: Medium  
**Time**: 20 minutes

### Task

Create a `TimeLock.sol` contract with:
- A modifier that prevents functions from being called before a certain timestamp
- Functions to set and check time locks

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract TimeLock {
    error TooEarly(uint256 currentTime, uint256 unlockTime);
    error NotAuthorized();
    
    mapping(bytes32 => uint256) public timeLocks;
    address public owner;
    
    modifier timeLockCheck(bytes32 lockId) {
        _timeLockCheck(lockId);
        _;
    }
    
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function setTimeLock(bytes32 lockId, uint256 unlockTime) public onlyOwner {
        timeLocks[lockId] = unlockTime;
    }
    
    function executeAction(bytes32 lockId) public timeLockCheck(lockId) {
        // Action that can only be executed after time lock
    }
    
    function _timeLockCheck(bytes32 lockId) internal view {
        uint256 unlockTime = timeLocks[lockId];
        if (unlockTime > 0 && block.timestamp < unlockTime) {
            revert TooEarly(block.timestamp, unlockTime);
        }
    }
    
    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotAuthorized();
    }
}
```

</details>

---

## Exercise 3.4: Rate Limiter Modifier ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 30 minutes

### Task

Create a `RateLimiter.sol` contract that:
- Limits how often a user can call a function
- Uses a modifier to enforce the rate limit
- Allows different rate limits for different functions

### Requirements

- Track last call time per user
- Configurable cooldown period
- Custom error with wait time information

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract RateLimiter {
    error RateLimitExceeded(uint256 waitTime);
    
    mapping(address => uint256) public lastCallTime;
    mapping(bytes32 => uint256) public cooldowns;
    uint256 public defaultCooldown = 60; // 60 seconds
    
    modifier rateLimit(bytes32 actionId) {
        _rateLimit(actionId);
        _;
    }
    
    function setCooldown(bytes32 actionId, uint256 cooldown) public {
        cooldowns[actionId] = cooldown;
    }
    
    function action1() public rateLimit("action1") {
        // Rate-limited action
    }
    
    function action2() public rateLimit("action2") {
        // Rate-limited action with different cooldown
    }
    
    function _rateLimit(bytes32 actionId) internal {
        uint256 cooldown = cooldowns[actionId];
        if (cooldown == 0) cooldown = defaultCooldown;
        
        uint256 waitTime = lastCallTime[msg.sender] + cooldown;
        if (block.timestamp < waitTime) {
            revert RateLimitExceeded(waitTime - block.timestamp);
        }
        
        lastCallTime[msg.sender] = block.timestamp;
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {RateLimiter} from "@src/week1/RateLimiter.sol";

contract RateLimiterTest is Test {
    RateLimiter public limiter;
    address public alice = makeAddr("alice");
    
    function setUp() public {
        limiter = new RateLimiter();
    }
    
    function testAction1() public {
        vm.startPrank(alice);
        limiter.action1();  // Should succeed
        
        // Second call should fail
        vm.expectRevert();
        limiter.action1();
        vm.stopPrank();
        
        // Wait 61 seconds
        vm.warp(block.timestamp + 61);
        
        vm.startPrank(alice);
        limiter.action1();  // Should succeed now
        vm.stopPrank();
    }
}
```

</details>

---

## Exercise 3.5: Emergency Pause System ⭐⭐

**Difficulty**: Medium  
**Time**: 20 minutes

### Task

Extend the `Week1_2.sol` contract with:
- An emergency withdraw function that works even when paused
- Event emission for pause/unpause actions
- Better error handling

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_2Enhanced {
    error NotOwner();
    error ContractIsPaused();
    
    event Paused(address indexed who);
    event Unpaused(address indexed who);
    event EmergencyWithdrawal(address indexed user, uint256 amount);
    
    bytes public encode;
    address public owner;
    mapping(address => uint256) public balances;
    
    enum IsPaused {
        Paused,
        Unpaused
    }
    
    IsPaused public isPaused;
    
    modifier whenPaused() {
        _whenPaused();
        _;
    }
    
    modifier whenNotPaused() {
        _whenNotPaused();
        _;
    }
    
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function deposit() public payable whenNotPaused {
        balances[msg.sender] += msg.value;
    }
    
    function setBytesByString(string calldata _encode) public whenPaused {
        encode = abi.encode(_encode);
    }
    
    // Emergency withdraw - works even when paused!
    function emergencyWithdraw() public {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "No balance");
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
        emit EmergencyWithdrawal(msg.sender, balance);
    }
    
    function pause() public onlyOwner {
        isPaused = IsPaused.Paused;
        emit Paused(owner);
    }
    
    function unpause() public onlyOwner {
        isPaused = IsPaused.Unpaused;
        emit Unpaused(owner);
    }
    
    function _whenPaused() internal view {
        if (isPaused == IsPaused.Paused) revert ContractIsPaused();
    }
    
    function _whenNotPaused() internal view {
        if (isPaused == IsPaused.Unpaused) revert ContractIsPaused();
    }
    
    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }
}
```

</details>

---

## ✅ Completion Checklist

Before moving to Module 4, ensure you can:

- [ ] Create custom modifiers with `_` placeholder
- [ ] Implement `onlyOwner` access control
- [ ] Use custom errors instead of `require` with strings
- [ ] Write constructors for initialization
- [ ] Apply the pause/unpause pattern
- [ ] Complete at least 3 exercises above

---

## 🎯 Challenge: Access Control System ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 40 minutes

### Task

Build a `SecureVault.sol` contract with:

**Requirements:**
1. Multiple access levels (Owner, Admin, User)
2. Time-locked withdrawals (24-hour delay)
3. Emergency pause functionality
4. Rate-limited deposits
5. Comprehensive event logging

**Features:**
- Owner can pause/unpause and set admins
- Admins can manage users
- Users can deposit and request withdrawals
- All withdrawals have 24-hour time lock
- Emergency pause stops all operations except emergency withdraw

---

**Ready for the next module?** → [Go to Module 4](../module-4/README.md)
