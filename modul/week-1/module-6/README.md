# Module 6: Events & Testing Fundamentals

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Define and emit events for off-chain tracking
- Understand event logs and indexing
- Write comprehensive Foundry tests
- Use `vm.prank`, `vm.expectRevert`, and fuzzing
- Structure test files following best practices

## 📚 Prerequisites

- Module 1-5: All previous modules ✅
- Basic understanding of Foundry (`forge test`)

## ⏱️ Estimated Time

45-60 minutes

---

## 📖 Core Concepts

### 1. Events - Blockchain Logging

**Events** are a way to log data on the blockchain that can be accessed by off-chain applications. They're like a "receipt" or "audit trail" for your contract.

From the transcription:
> *"event emit itu cuma ditulis di write function"*
> *"event itu data yang didapat dari blockchain, bersifat historikal, untuk diolah di offchain"*

### Basic Event Syntax

```solidity
// Define the event
event Transfer(address indexed from, address indexed to, uint256 amount);

// Emit the event
function transfer(address to, uint256 amount) public {
    balances[msg.sender] -= amount;
    balances[to] += amount;
    
    emit Transfer(msg.sender, to, amount);  // Log the transfer
}
```

### Indexed Parameters

```solidity
// Can have up to 3 indexed parameters
event OrderCreated(
    address indexed buyer,    // Indexed - can filter by this
    uint256 indexed orderId,  // Indexed - can filter by this
    uint256 amount,           // Not indexed - data only
    string description        // Not indexed - data only
);
```

**Indexed vs Non-Indexed:**
- **Indexed**: Can be filtered/searched (like a database index)
- **Non-Indexed**: Stored in logs but can't filter by them

---

### 2. Common Event Patterns

#### **State Change Events**

```solidity
event BalanceUpdated(address indexed user, uint256 oldBalance, uint256 newBalance);

function deposit(uint256 amount) public {
    uint256 oldBalance = balances[msg.sender];
    balances[msg.sender] += amount;
    
    emit BalanceUpdated(msg.sender, oldBalance, balances[msg.sender]);
}
```

#### **Action Events**

```solidity
event UserRegistered(address indexed user, uint256 timestamp, string name);

function register(string calldata name) public {
    // ... registration logic
    
    emit UserRegistered(msg.sender, block.timestamp, name);
}
```

#### **Error/Warning Events**

```solidity
event EmergencyPause(address indexed who, uint256 timestamp, string reason);

function emergencyPause(string calldata reason) public onlyOwner {
    paused = true;
    emit EmergencyPause(msg.sender, block.timestamp, reason);
}
```

---

### 3. Foundry Testing Fundamentals

From the transcription:
> *"forge test basicnya force test ini semua yang ada di force test bakal ke unit test"*

#### **Test File Structure**

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {MyContract} from "@src/week1/MyContract.sol";

contract MyContractTest is Test {
    MyContract public contract;
    
    // Setup runs before each test
    function setUp() public {
        contract = new MyContract();
    }
    
    // Test functions start with "test"
    function testSomething() public {
        // Test logic here
        assertEq(contract.value(), 100);
    }
}
```

---

### 4. Foundry Cheat Codes

#### **vm.prank - Impersonate Accounts**

```solidity
function testOnlyOwner() public {
    address alice = makeAddr("alice");
    
    // Prank: Execute next call as alice
    vm.prank(alice);
    contract.someFunction();  // Called as alice
    
    // Start prank: All calls until stopPrank are as alice
    vm.startPrank(alice);
    contract.function1();
    contract.function2();
    vm.stopPrank();
}
```

#### **vm.expectRevert - Test Reverts**

```solidity
function testRevert() public {
    // Expect any revert
    vm.expectRevert();
    contract.functionThatReverts();
    
    // Expect specific error (custom error)
    vm.expectRevert(MyContract.NotOwner.selector);
    contract.onlyOwnerFunction();
    
    // Expect specific error (string)
    vm.expectRevert("Insufficient balance");
    contract.withdraw(1000);
}
```

#### **makeAddr - Create Named Addresses**

```solidity
address alice = makeAddr("alice");  // Deterministic address
address bob = makeAddr("bob");

// These addresses are consistent across test runs
```

---

### 5. Fuzz Testing

**Fuzz testing** runs your test with random inputs to find edge cases.

```solidity
// Regular test - runs once
function testSetNumber() public {
    contract.setNumber(42);
    assertEq(contract.getNumber(), 42);
}

// Fuzz test - runs many times with random values
function testFuzzSetNumber(uint256 x) public {
    contract.setNumber(x);
    assertEq(contract.getNumber(), x);
}
```

From the transcription:
> *"testFuzz_SetNumber(uint256 x)"*

**How it works:**
- Foundry runs the test ~256 times with different random values
- Finds edge cases you might not think of
- Automatically shrinks failing inputs to minimal case

---

### 6. Test Organization

#### **Naming Conventions**

```solidity
// Test function naming
function test_Increment() public;           // Basic test
function testFuzz_SetNumber(uint256 x) public;  // Fuzz test
function test_WhenPaused_Reverts() public;  // Condition-based
```

#### **Test Commands**

```bash
# Run all tests
forge test

# Run specific contract tests
forge test --match-contract Week1_1Test

# Run specific test function
forge test --match-test testIncrement

# Run with verbosity
forge test -vvv

# Run with gas report
forge test --gas-report
```

---

## 🔍 Code Walkthrough

Let's analyze the test files:

### `Week.1.t.sol`

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Week1_1} from "@src/week1/Week1_1.sol";

contract Week1_1Test is Test {
    Week1_1 public week11;
    
    // setUp runs before EACH test
    function setUp() public {
        week11 = new Week1_1();
        week11.setNumber(0);
    }
    
    // Basic test
    function testSetNumber() public {
        week11.setNumber(1);
        assertEq(week11.number(), 1);
    }
    
    // Test with setup dependency
    function testIncrement() public {
        week11.increment();
        assertEq(week11.number(), 1);
    }
    
    // Test that builds on another test
    function testDecrement() public {
        testIncrement();  // number = 1
        week11.decrement();
        assertEq(week11.number(), 0);
    }
    
    // View function test
    function testGetNumber() public view {
        assertEq(week11.getNumber(), 0);
    }
}
```

### `Week.1.2.t.sol` - Using vm.prank

```solidity
contract Week1_2Test is Test {
    Week1_2 public week12;
    
    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");
    
    function setUp() public {
        // Deploy as owner
        vm.startPrank(owner);
        week12 = new Week1_2();
        vm.stopPrank();
    }
    
    function testSetBytesByString() public {
        week12.setBytesByString("Hello");
        assertEq(week12.encode(), abi.encode("Hello"));
    }
    
    function testPause() public {
        vm.startPrank(owner);  // Only owner can pause
        week12.pause();
        vm.stopPrank();
    }
    
    function testSetBytesByStringWhenPaused() public {
        // Pause as owner
        vm.startPrank(owner);
        week12.pause();
        vm.stopPrank();
        
        // Now try to set bytes (should work because whenPaused modifier)
        vm.startPrank(owner);
        week12.setBytesByString("Hello");
        vm.stopPrank();
    }
}
```

---

## 🛠️ Hands-On Exercises

### Exercise 6.1: Add Events to Contract

**Task**: Add comprehensive events to a simple bank contract.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract BankWithEvents {
    // Events
    event Deposited(address indexed user, uint256 amount, uint256 newBalance);
    event Withdrawn(address indexed user, uint256 amount, uint256 newBalance);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        require(msg.value > 0, "Must deposit something");
        balances[msg.sender] += msg.value;
        
        emit Deposited(msg.sender, msg.value, balances[msg.sender]);
    }
    
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
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

---

### Exercise 6.2: Write Comprehensive Tests

**Task**: Write tests for the bank contract using Foundry cheat codes.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {BankWithEvents} from "@src/week1/BankWithEvents.sol";

contract BankWithEventsTest is Test {
    BankWithEvents public bank;
    
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    
    function setUp() public {
        bank = new BankWithEvents();
    }
    
    function testDeposit() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        
        assertEq(bank.balances(alice), 1 ether);
        vm.stopPrank();
    }
    
    function testWithdraw() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        bank.withdraw(0.5 ether);
        
        assertEq(bank.balances(alice), 0.5 ether);
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
    
    function testFuzzDeposit(uint256 amount) public {
        vm.assume(amount > 0 && amount < 1000 ether);
        
        vm.startPrank(alice);
        bank.deposit{value: amount}();
        
        assertEq(bank.balances(alice), amount);
        vm.stopPrank();
    }
}
```

---

## ⚠️ Common Pitfalls

### 1. Not Using Indexed Parameters

```solidity
// ❌ Hard to filter
event Transfer(address from, address to, uint256 amount);

// ✅ Easy to filter
event Transfer(address indexed from, address indexed to, uint256 amount);
```

### 2. Forgetting to Emit Events

```solidity
// ❌ No audit trail
function transfer(address to, uint256 amount) public {
    balances[msg.sender] -= amount;
    balances[to] += amount;
}

// ✅ With event
function transfer(address to, uint256 amount) public {
    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
}
```

### 3. Testing Without setUp

```solidity
// ❌ Creating contract in each test
function test1() public {
    MyContract c = new MyContract();
    // ...
}

function test2() public {
    MyContract c = new MyContract();
    // ...
}

// ✅ Using setUp
function setUp() public {
    c = new MyContract();
}

function test1() public {
    // c is already created
}
```

---

## 📝 Self-Check Quiz

1. **What's the maximum number of indexed parameters in an event?**
   <details><summary>Answer</summary>3</details>

2. **Can events be read from within a smart contract?**
   <details><summary>Answer</summary>No, events are for off-chain consumption only</details>

3. **What does `vm.prank()` do?**
   <details><summary>Answer</summary>Makes the next call appear to come from a specific address</details>

4. **What's the difference between `vm.prank()` and `vm.startPrank()`?**
   <details><summary>Answer</summary>`prank()` affects only the next call, `startPrank()` affects all calls until `stopPrank()`</details>

5. **How many times does Foundry run a fuzz test by default?**
   <details><summary>Answer</summary>256 runs (256 different random inputs)</details>

---

## 📚 Additional Resources

- **Foundry Docs**: [Testing](https://book.getfoundry.sh/forge/tests)
- **Foundry Docs**: [Cheat Codes](https://book.getfoundry.sh/cheatcodes/)
- **Solidity Docs**: [Events](https://docs.soliditylang.org/en/latest/contracts.html#events)
- **Cyfrin Updraft**: Testing Best Practices

---

## 🎯 What's Next?

Congratulations! You've completed Week 1! Now you should:

1. Review all modules and complete any unfinished exercises
2. Practice by reading and understanding the existing contracts in `src/week1/`
3. Try to extend the contracts with new features
4. Write comprehensive tests for your extensions

**Continue your journey:**
- Explore advanced Solidity patterns
- Learn about upgradeable contracts
- Study security best practices
- Build your own project!

---

## 🏆 Week 1 Completion Checklist

- [ ] Module 1: Data Types - Quiz passed (50+ points)
- [ ] Module 2: Functions & Visibility - Quiz passed (55+ points)
- [ ] Module 3: Modifiers & Access Control - Quiz passed (55+ points)
- [ ] Module 4: Bytes & Encoding - Quiz passed (55+ points)
- [ ] Module 5: Structs, Enums & Mappings - Quiz passed (55+ points)
- [ ] Module 6: Events & Testing - Quiz passed (55+ points)
- [ ] Completed at least 2 exercises per module
- [ ] Can explain all key concepts from the transcription

**You're ready for Week 2!** 🎉
