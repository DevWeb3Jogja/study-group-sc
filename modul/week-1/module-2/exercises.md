# Module 2: Exercises

## Practice Tasks for Functions & Visibility

---

## Exercise 2.1: Visibility Practice ⭐

**Difficulty**: Easy  
**Time**: 15 minutes

### Task

Create a contract `VisibilityDemo.sol` that demonstrates all four visibility types:

1. One `public` function that modifies state
2. One `external` function that modifies state
3. One `internal` function that modifies state
4. One `private` function that modifies state
5. One `public view` function that reads state
6. One `public pure` function that performs calculation

### Requirements

- Create a state variable `uint256 public value`
- Each function should modify/read this value appropriately
- Create a `public` function that calls both internal and private functions

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract VisibilityDemo {
    uint256 public value = 0;
    
    // PUBLIC: Anyone can call
    function setValue(uint256 _value) public {
        value = _value;
    }
    
    // EXTERNAL: External calls only
    function setValueExternal(uint256 _value) external {
        value = _value;
    }
    
    // INTERNAL: Contract and children only
    function _incrementInternal() internal {
        value++;
    }
    
    // PRIVATE: Contract only
    function _doublePrivate() private {
        value *= 2;
    }
    
    // Public function that uses internal functions
    function process() public {
        _incrementInternal();
        _doublePrivate();
    }
    
    // VIEW: Read without gas cost
    function getValue() public view returns (uint256) {
        return value;
    }
    
    // PURE: No state access
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {VisibilityDemo} from "@src/week1/VisibilityDemo.sol";

contract VisibilityDemoTest is Test {
    VisibilityDemo public demo;

    function setUp() public {
        demo = new VisibilityDemo();
    }

    function testPublicFunction() public {
        demo.setValue(10);
        assertEq(demo.value(), 10);
    }

    function testExternalFunction() public {
        demo.setValueExternal(20);
        assertEq(demo.value(), 20);
    }

    function testInternalAndPrivate() public {
        demo.process();  // Calls internal and private
        assertEq(demo.value(), 2);  // (0 + 1) * 2 = 2
    }

    function testViewFunction() public view {
        uint256 val = demo.getValue();
        assertEq(val, 0);
    }

    function testPureFunction() public view {
        uint256 result = demo.add(5, 3);
        assertEq(result, 8);
    }
}
```

</details>

---

## Exercise 2.2: Bank Contract ⭐⭐

**Difficulty**: Medium  
**Time**: 20 minutes

### Task

Create a `SimpleBank.sol` contract with proper function visibility:

**Functions needed:**
1. `deposit()` - Users can deposit ether (public/external)
2. `withdraw(uint256 amount)` - Users can withdraw (public/external)
3. `getBalance(address user)` - Check user balance (view function)
4. `_calculateFee(uint256 amount)` - Calculate withdrawal fee (internal)
5. `_isValidAmount(uint256 amount)` - Validate amount (private)

### Requirements

- Use `mapping(address => uint256)` to track balances
- Charge a 1% fee on withdrawals (use internal function)
- Validate amounts with private function

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract SimpleBank {
    mapping(address => uint256) public balances;
    
    /// @notice Deposit ether into the bank
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    /// @notice Withdraw ether from the bank
    /// @param amount The amount to withdraw
    function withdraw(uint256 amount) public {
        require(_isValidAmount(amount), "Invalid amount");
        require(balances[msg.sender] >= amount + _calculateFee(amount), "Insufficient balance");
        
        uint256 fee = _calculateFee(amount);
        balances[msg.sender] -= (amount + fee);
        
        payable(msg.sender).transfer(amount);
        // Fee stays in contract
    }
    
    /// @notice Get balance of a user
    /// @param user The address to check
    /// @return The balance
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
    
    /// @notice Calculate withdrawal fee (1%)
    /// @param amount The withdrawal amount
    /// @return The fee amount
    function _calculateFee(uint256 amount) internal pure returns (uint256) {
        return amount / 100;  // 1% fee
    }
    
    /// @notice Validate amount is greater than 0
    /// @param amount The amount to validate
    /// @return True if valid
    function _isValidAmount(uint256 amount) private pure returns (bool) {
        return amount > 0;
    }
}
```

</details>

---

## Exercise 2.3: View vs Pure ⭐

**Difficulty**: Easy  
**Time**: 10 minutes

### Task

Create a contract `Calculator.sol` with the following functions:

1. A `view` function that reads a state variable and performs calculation
2. A `pure` function that only uses parameters

### Test Your Understanding

Write tests that show the gas difference between calling these functions externally vs internally.

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Calculator {
    uint256 public baseNumber = 100;
    
    // VIEW: Reads state variable
    function addBase(uint256 number) public view returns (uint256) {
        return baseNumber + number;
    }
    
    // PURE: Only uses parameters
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
    
    // VIEW: Multiple calculations
    function calculateWithBase(uint256 multiplier) public view returns (uint256) {
        return baseNumber * multiplier + baseNumber;
    }
    
    // PURE: Complex calculation without state
    function compound(uint256 principal, uint256 rate, uint256 time) 
        public 
        pure 
        returns (uint256) 
    {
        return principal * (100 + rate) ** time / 100 ** time;
    }
}
```

</details>

---

## Exercise 2.4: Inheritance & Visibility ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 25 minutes

### Task

Create two contracts that demonstrate inheritance with different visibility levels:

1. `BaseContract` with functions of all visibility types
2. `ChildContract` that inherits from `BaseContract`

### Requirements

- `BaseContract` should have `public`, `external`, `internal`, and `private` functions
- `ChildContract` should try to call parent functions
- Document which functions can/cannot be accessed

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract BaseContract {
    uint256 public data = 10;
    
    // PUBLIC: Accessible everywhere
    function publicFunc() public {
        data++;
    }
    
    // EXTERNAL: Only external calls
    function externalFunc() external {
        data += 2;
    }
    
    // INTERNAL: Accessible in child contracts
    function _internalFunc() internal {
        data += 3;
    }
    
    // PRIVATE: NOT accessible in child contracts
    function _privateFunc() private {
        data += 4;
    }
    
    // Public wrapper to test private
    function testPrivate() public {
        _privateFunc();
    }
}

contract ChildContract is BaseContract {
    // Can call public from parent
    function callPublicParent() public {
        publicFunc();  // ✅ Works
    }
    
    // Cannot directly call external from parent internally
    // function callExternalParent() public {
    //     externalFunc();  // ❌ Won't compile
    // }
    
    // Can call internal from parent
    function callInternalParent() public {
        _internalFunc();  // ✅ Works
    }
    
    // Cannot call private from parent
    // function callPrivateParent() public {
    //     _privateFunc();  // ❌ Won't compile
    // }
    
    function getData() public view returns (uint256) {
        return data;
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {BaseContract, ChildContract} from "@src/week1/InheritanceDemo.sol";

contract InheritanceTest is Test {
    ChildContract public child;

    function setUp() public {
        child = new ChildContract();
    }

    function testCallPublicParent() public {
        child.callPublicParent();
        assertEq(child.data(), 11);  // 10 + 1
    }

    function testCallInternalParent() public {
        child.callInternalParent();
        assertEq(child.data(), 13);  // 10 + 3
    }

    function testMultipleCalls() public {
        child.callPublicParent();      // +1
        child.callInternalParent();    // +3
        assertEq(child.data(), 14);    // 10 + 1 + 3
    }
}
```

</details>

---

## Exercise 2.5: Gas Optimization Awareness ⭐⭐

**Difficulty**: Medium  
**Time**: 15 minutes

### Task

Research and experiment with gas costs:

1. Create two functions that do the same calculation:
   - One as `public`
   - One as `external`
2. Use `forge test --gas-report` to compare gas costs
3. Document your findings

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract GasComparison {
    uint256[] public numbers;
    
    // PUBLIC with memory array
    function processPublic(uint256[] memory _numbers) public {
        for (uint256 i = 0; i < _numbers.length; i++) {
            numbers.push(_numbers[i]);
        }
    }
    
    // EXTERNAL with calldata (more efficient)
    function processExternal(uint256[] calldata _numbers) external {
        for (uint256 i = 0; i < _numbers.length; i++) {
            numbers.push(_numbers[i]);
        }
    }
    
    function getNumbersLength() public view returns (uint256) {
        return numbers.length;
    }
}
```

**Run gas report**:
```bash
forge test --gas-report
```

**Expected finding**: `external` with `calldata` is cheaper than `public` with `memory` for large arrays.

</details>

---

## ✅ Completion Checklist

Before moving to Module 3, ensure you can:

- [ ] Explain the difference between all four visibility types
- [ ] Know when to use `view` vs `pure`
- [ ] Understand gas implications of different function types
- [ ] Complete at least 3 exercises above
- [ ] Write functions with proper visibility in your own contracts

---

## 🎯 Challenge: Access Control System ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 30 minutes

### Task

Build a `DocumentManager.sol` contract:

**Requirements:**
1. Store documents (as strings) with owner addresses
2. Only document owners can edit their documents
3. Anyone can read documents
4. Use appropriate visibility for all functions
5. Include view functions for reading

**Hint**: Use `mapping(uint256 => Document)` where Document is a struct.

---

**Ready for the next module?** → [Go to Module 3](../module-3/README.md)
