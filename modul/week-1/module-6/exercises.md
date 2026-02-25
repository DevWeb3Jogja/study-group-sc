# Module 6: Exercises

## Practice Tasks for Events & Testing

---

## Exercise 6.1: Add Events to Contract ⭐

**Difficulty**: Easy  
**Time**: 15 minutes

### Task

Add comprehensive events to a simple bank contract. Include events for:
- Deposits
- Withdrawals
- Transfers
- Account creation

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract BankWithEvents {
    // Events
    event AccountCreated(address indexed user, uint256 timestamp);
    event Deposited(address indexed user, uint256 amount, uint256 newBalance);
    event Withdrawn(address indexed user, uint256 amount, uint256 newBalance);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    mapping(address => uint256) public balances;
    mapping(address => bool) public hasAccount;
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit something");
        
        // Create account if doesn't exist
        if (!hasAccount[msg.sender]) {
            hasAccount[msg.sender] = true;
            emit AccountCreated(msg.sender, block.timestamp);
        }
        
        uint256 oldBalance = balances[msg.sender];
        balances[msg.sender] += msg.value;
        
        emit Deposited(msg.sender, msg.value, balances[msg.sender]);
    }
    
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        uint256 oldBalance = balances[msg.sender];
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        
        emit Withdrawn(msg.sender, amount, balances[msg.sender]);
    }
    
    function transferTo(address to, uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
    }
}
```

</details>

---

## Exercise 6.2: Write Comprehensive Tests ⭐⭐

**Difficulty**: Medium  
**Time**: 30 minutes

### Task

Write tests for the bank contract using:
- `vm.prank()` for different users
- `vm.expectRevert()` for error cases
- Fuzz testing for edge cases
- `makeAddr()` for named addresses

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {BankWithEvents} from "@src/week1/BankWithEvents.sol";

contract BankWithEventsTest is Test {
    BankWithEvents public bank;
    
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public owner = makeAddr("owner");
    
    function setUp() public {
        bank = new BankWithEvents();
    }
    
    function testDeposit() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        
        assertEq(bank.balances(alice), 1 ether);
        assertTrue(bank.hasAccount(alice));
        vm.stopPrank();
    }
    
    function testWithdraw() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        
        uint256 balanceBefore = address(alice).balance;
        bank.withdraw(0.5 ether);
        uint256 balanceAfter = address(alice).balance;
        
        assertEq(bank.balances(alice), 0.5 ether);
        assertEq(balanceAfter - balanceBefore, 0.5 ether);
        vm.stopPrank();
    }
    
    function testWithdrawInsufficientBalance() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        
        vm.expectRevert("Insufficient balance");
        bank.withdraw(2 ether);
        vm.stopPrank();
    }
    
    function testTransfer() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        bank.transferTo(bob, 0.3 ether);
        vm.stopPrank();
        
        assertEq(bank.balances(alice), 0.7 ether);
        assertEq(bank.balances(bob), 0.3 ether);
    }
    
    function testTransferToZeroAddress() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        
        vm.expectRevert();
        bank.transferTo(address(0), 0.3 ether);
        vm.stopPrank();
    }
    
    function testFuzzDeposit(uint256 amount) public {
        vm.assume(amount > 0 && amount < 1000 ether);
        
        vm.startPrank(alice);
        bank.deposit{value: amount}();
        
        assertEq(bank.balances(alice), amount);
        vm.stopPrank();
    }
    
    function testFuzzTransfer(uint256 amount) public {
        vm.assume(amount > 0 && amount < 100 ether);
        
        vm.startPrank(alice);
        bank.deposit{value: 100 ether};
        bank.transferTo(bob, amount);
        vm.stopPrank();
        
        assertEq(bank.balances(alice), 100 ether - amount);
        assertEq(bank.balances(bob), amount);
    }
    
    function testMultipleUsers() public {
        // Alice deposits
        vm.prank(alice);
        bank.deposit{value: 1 ether}();
        
        // Bob deposits
        vm.prank(bob);
        bank.deposit{value: 2 ether}();
        
        // Alice transfers to Bob
        vm.prank(alice);
        bank.transferTo(bob, 0.5 ether);
        
        assertEq(bank.balances(alice), 0.5 ether);
        assertEq(bank.balances(bob), 2.5 ether);
    }
}
```

</details>

---

## Exercise 6.3: Test Access Control ⭐⭐

**Difficulty**: Medium  
**Time**: 25 minutes

### Task

Write tests for a contract with `onlyOwner` and `whenPaused` modifiers. Test:
- Owner-only functions
- Paused state restrictions
- Error messages with `vm.expectRevert`

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Week1_2} from "@src/week1/Week1_2.sol";

contract Week1_2Test is Test {
    Week1_2 public week12;
    
    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    
    function setUp() public {
        vm.startPrank(owner);
        week12 = new Week1_2();
        vm.stopPrank();
    }
    
    function testOwnerCanSetBytes() public {
        vm.startPrank(owner);
        week12.setBytesByString("Hello");
        vm.stopPrank();
        
        assertEq(week12.decodeBytesToString(), "Hello");
    }
    
    function testNonOwnerCannotSetBytes() public {
        vm.startPrank(alice);
        
        vm.expectRevert(Week1_2.NotOwner.selector);
        week12.setBytesByString("Hello");
        
        vm.stopPrank();
    }
    
    function testOwnerCanPause() public {
        vm.startPrank(owner);
        week12.pause();
        vm.stopPrank();
    }
    
    function testNonOwnerCannotPause() public {
        vm.startPrank(alice);
        
        vm.expectRevert(Week1_2.NotOwner.selector);
        week12.pause();
        
        vm.stopPrank();
    }
    
    function testCannotSetBytesWhenNotPaused() public {
        vm.startPrank(owner);
        
        vm.expectRevert(Week1_2.ContractIsPaused.selector);
        week12.setBytesByString("Hello");
        
        vm.stopPrank();
    }
    
    function testCanSetBytesWhenPaused() public {
        // Pause first
        vm.startPrank(owner);
        week12.pause();
        vm.stopPrank();
        
        // Now set bytes
        vm.startPrank(owner);
        week12.setBytesByString("Hello");
        vm.stopPrank();
        
        assertEq(week12.decodeBytesToString(), "Hello");
    }
}
```

</details>

---

## Exercise 6.4: Event Testing ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 35 minutes

### Task

Write tests that verify events are emitted correctly using Foundry's event checking.

### Requirements

- Use `vm.recordLogs()` to capture events
- Verify event parameters
- Test multiple events in one transaction

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {BankWithEvents} from "@src/week1/BankWithEvents.sol";

contract EventTestingTest is Test {
    BankWithEvents public bank;
    
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    
    function setUp() public {
        bank = new BankWithEvents();
    }
    
    function testDepositEvent() public {
        vm.startPrank(alice);
        
        // Record logs
        vm.recordLogs();
        
        bank.deposit{value: 1 ether}();
        
        // Get logs
        Vm.Log[] memory entries = vm.getRecordedLogs();
        
        // Should have 2 events: AccountCreated and Deposited
        assertEq(entries.length, 2);
        
        // Check Deposited event (second event)
        assertEq(entries[1].topics[0], keccak256("Deposited(address,uint256,uint256)"));
        assertEq(entries[1].topics[1], bytes32(uint256(uint160(alice))));
        
        vm.stopPrank();
    }
    
    function testTransferEvents() public {
        // Setup: Alice deposits
        vm.prank(alice);
        bank.deposit{value: 1 ether}();
        
        vm.startPrank(alice);
        vm.recordLogs();
        
        bank.transferTo(bob, 0.3 ether);
        
        Vm.Log[] memory entries = vm.getRecordedLogs();
        
        // Should have 1 event: Transfer
        assertEq(entries.length, 1);
        assertEq(entries[0].topics[0], keccak256("Transfer(address,address,uint256)"));
        
        // Check from address (topics[1])
        assertEq(entries[0].topics[1], bytes32(uint256(uint160(alice))));
        
        // Check to address (topics[2])
        assertEq(entries[0].topics[2], bytes32(uint256(uint160(bob))));
        
        vm.stopPrank();
    }
}
```

</details>

---

## Exercise 6.5: Integration Test ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 45 minutes

### Task

Write an integration test that tests a complete user flow:
1. User registers
2. User deposits
3. User transfers
4. Recipient withdraws

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {BankWithEvents} from "@src/week1/BankWithEvents.sol";

contract IntegrationTest is Test {
    BankWithEvents public bank;
    
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public charlie = makeAddr("charlie");
    
    function setUp() public {
        bank = new BankWithEvents();
    }
    
    function testCompleteUserFlow() public {
        // Step 1: Alice deposits
        vm.startPrank(alice);
        bank.deposit{value: 10 ether}();
        assertEq(bank.balances(alice), 10 ether);
        vm.stopPrank();
        
        // Step 2: Bob deposits
        vm.startPrank(bob);
        bank.deposit{value: 5 ether}();
        assertEq(bank.balances(bob), 5 ether);
        vm.stopPrank();
        
        // Step 3: Alice transfers to Bob
        vm.startPrank(alice);
        bank.transferTo(bob, 3 ether);
        assertEq(bank.balances(alice), 7 ether);
        assertEq(bank.balances(bob), 8 ether);
        vm.stopPrank();
        
        // Step 4: Bob transfers to Charlie
        vm.startPrank(bob);
        bank.transferTo(charlie, 2 ether);
        assertEq(bank.balances(bob), 6 ether);
        assertEq(bank.balances(charlie), 2 ether);
        vm.stopPrank();
        
        // Step 5: Charlie withdraws
        uint256 charlieBalanceBefore = address(charlie).balance;
        vm.startPrank(charlie);
        bank.withdraw(2 ether);
        uint256 charlieBalanceAfter = address(charlie).balance;
        vm.stopPrank();
        
        assertEq(bank.balances(charlie), 0);
        assertEq(charlieBalanceAfter - charlieBalanceBefore, 2 ether);
        
        // Step 6: Verify total balance
        assertEq(bank.balances(alice) + bank.balances(bob) + bank.balances(charlie), 13 ether);
    }
    
    function testMultipleTransactions() public {
        // Simulate many users
        address[] memory users = new address[](10);
        for (uint256 i = 0; i < 10; i++) {
            users[i] = makeAddr(string(abi.encodePacked("user", vm.toString(i))));
            
            vm.startPrank(users[i]);
            bank.deposit{value: 1 ether}();
            vm.stopPrank();
        }
        
        // Transfer between users
        for (uint256 i = 0; i < 9; i++) {
            vm.startPrank(users[i]);
            bank.transferTo(users[i + 1], 0.1 ether);
            vm.stopPrank();
        }
        
        // Verify final balances
        assertEq(bank.balances(users[0]), 0.9 ether);
        for (uint256 i = 1; i < 9; i++) {
            assertEq(bank.balances(users[i]), 1 ether);  // Received 0.1, sent 0.1
        }
        assertEq(bank.balances(users[9]), 1.1 ether);  // Only received
    }
}
```

</details>

---

## ✅ Completion Checklist

Before considering Week 1 complete, ensure you can:

- [ ] Define and emit events properly
- [ ] Use indexed parameters for filterable events
- [ ] Write tests with `setUp()` for initialization
- [ ] Use `vm.prank()` and `vm.startPrank()` for impersonation
- [ ] Use `vm.expectRevert()` to test error cases
- [ ] Write fuzz tests with random inputs
- [ ] Use `makeAddr()` for named test addresses
- [ ] Complete at least 3 exercises above

---

## 🎯 Challenge: Full Test Suite ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 60 minutes

### Task

Write a complete test suite for `Week1_3.sol` (User management with structs and mappings):

**Requirements:**
1. Test user registration
2. Test user editing
3. Test duplicate user prevention
4. Test with multiple users
5. Include fuzz testing
6. Verify all events

---

**Congratulations on completing Week 1!** 🎉

Continue to the [Week 1 Overview](../README.md) for next steps.
