# Module 2: Functions & Visibility

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Understand and use different function visibility specifiers (public, external, internal, private)
- Differentiate between view, pure, and state-changing functions
- Understand gas implications of different function types
- Write properly structured functions with returns
- Apply object-oriented programming concepts to Solidity

## 📚 Prerequisites

- Module 1: Solidity Basics & Data Types ✅
- Understanding of state variables
- Basic function syntax

## ⏱️ Estimated Time

30-45 minutes

---

## 📖 Core Concepts

### 1. Function Visibility Specifiers

In Solidity, functions must have a visibility specifier that determines **who can call them**. From the transcription:

> *"public external, private, internal, special case: view function"*

Let's break down each type:

#### **public** - Anyone Can Call ✅

```solidity
function setNumber(uint256 newNumber) public {
    number = newNumber;
}
```

**Characteristics:**
- ✅ Can be called by **anyone** (users, other contracts, derived contracts)
- ✅ Creates an automatic **getter function** for external access
- ✅ Most common visibility for functions that need external access

**Use when:** You want the function to be callable from anywhere.

---

#### **external** - External Calls Only 🔌

```solidity
function setData(bytes calldata data) external {
    // Can only be called externally or via this.data()
}
```

**Characteristics:**
- ✅ Can be called by **external users** and **other contracts**
- ❌ **Cannot** be called internally within the same contract (except with `this.functionName()`)
- ✅ More gas-efficient for large data parameters (uses `calldata`)
- ✅ Common in interfaces and standards (ERC20, ERC721)

**Use when:** Building interfaces or when you want to enforce external-only access.

From the transcription:
> *"external bisa dieksekusi tapi tidak bisa diwariskan"* (external can be executed but cannot be inherited)

⚠️ **Note**: The transcription is slightly misleading. External functions CAN be inherited, but they cannot be called **internally** without `this.`.

---

#### **internal** - Contract & Inheritance Only 🔒

```solidity
function _calculateFee(uint256 amount) internal pure returns (uint256) {
    return amount * 5 / 100;  // 5% fee
}
```

**Characteristics:**
- ✅ Can be called by the **contract itself**
- ✅ Can be called by **contracts that inherit** from this contract
- ❌ Cannot be called by external users
- ✅ Often prefixed with `_` to indicate internal use

**Use when:** Creating helper functions or functions meant to be overridden by child contracts.

From the transcription:
> *"internal function hanya bisa dieksekusi oleh contractnya sendiri"* (internal functions can only be executed by the contract itself)

---

#### **private** - Contract Only Only 🔐

```solidity
function _generateId() private view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
}
```

**Characteristics:**
- ✅ Can **only** be called by the **contract itself**
- ❌ Cannot be called by inherited contracts
- ❌ Cannot be called externally
- ✅ Maximum privacy within the contract

**Use when:** Sensitive logic that should never be exposed to child contracts.

From the transcription:
> *"private itu bisa tidak dieksekusi sama deployer contractnya? Cuma kontraknya sendiri?"* ✅ Correct!

---

### 2. Visibility Comparison Table

| Visibility | Internal Call | External Call | Inherited Contract | External User |
|------------|--------------|---------------|-------------------|---------------|
| `public`   | ✅ Yes       | ✅ Yes        | ✅ Yes            | ✅ Yes        |
| `external` | ❌ No*      | ✅ Yes        | ✅ Yes            | ✅ Yes        |
| `internal` | ✅ Yes       | ❌ No         | ✅ Yes            | ❌ No         |
| `private`  | ✅ Yes       | ❌ No         | ❌ No             | ❌ No         |

*Except with `this.functionName()`

---

### 3. View & Pure Functions (Read Functions)

#### **view** - Read-Only Functions 👁️

```solidity
function getNumber() public view returns (uint256) {
    return number;
}
```

**Characteristics:**
- ✅ **Cannot modify** state variables
- ✅ Can **read** state variables
- ✅ **No gas cost** when called externally (off-chain)
- ✅ Gas is charged when called internally by other transactions

From the transcription:
> *"view function tidak boleh mengubah state variable, kalau read function itu nggak akan makan gas fee"*

**Use when:** You need to read data without changing anything.

---

#### **pure** - Pure Functions 🧪

```solidity
function add(uint256 a, uint256 b) public pure returns (uint256) {
    return a + b;
}
```

**Characteristics:**
- ✅ **Cannot read** state variables
- ✅ **Cannot modify** state variables
- ✅ Only uses input parameters
- ✅ **No gas cost** when called externally

**Use when:** Performing calculations that don't depend on contract state.

---

### 4. Function Visibility Hierarchy

```
Most Accessible                    Least Accessible
     ↓                                   ↓
┌─────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐
│ public  │ →│ external │  │ internal │ →│ private │
└─────────┘  └──────────┘  └──────────┘  └─────────┘
     ↑                                   ↑
 Anyone can call                Contract-only access
```

---

## 🔍 Code Walkthrough

Let's analyze `Week1_1.sol`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_1 {
    // Events (we'll cover these in Module 6)
    event SetNumber(address executor, uint256 newNumber);
    event Increment(uint256 newNumber);
    event Decrement(uint256 newNumber);

    uint256 public number;  // State variable with auto-generated getter

    /// @notice Sets a new number
    /// @dev This is a PUBLIC function - anyone can call it
    /// @param newNumber The new number to set
    function setNumber(uint256 newNumber) public {
        number = newNumber;
        emit SetNumber(msg.sender, newNumber);
    }

    /// @notice Increments the number by 1
    /// @dev PUBLIC function that modifies state
    function increment() public {
        number++;
        emit Increment(number);
    }

    /// @notice Decrements the number by 1
    /// @dev EXTERNAL function - can only be called externally
    function decrement() external {
        number--;
        emit Decrement(number);
    }

    /// @notice Gets the current number
    /// @dev VIEW function - reads state without modifying, no gas cost externally
    /// @return The current number
    function getNumber() public view returns (uint256) {
        return number;
    }
}
```

### Key Observations:

1. **`setNumber` is `public`**: Anyone can set the number (not secure for production!)
2. **`increment` is `public`**: Can be called internally or externally
3. **`decrement` is `external`**: Must be called from outside (or with `this.decrement()`)
4. **`getNumber` is `view`**: Only reads data, doesn't modify state

---

## 🛠️ Hands-On Exercises

### Exercise 2.1: Visibility Practice

**Task**: Create a contract that demonstrates all four visibility types.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract VisibilityDemo {
    uint256 public data;
    
    // PUBLIC: Anyone can call
    function setData(uint256 _data) public {
        data = _data;
    }
    
    // EXTERNAL: External calls only
    function setDataExternal(uint256 _data) external {
        data = _data;
    }
    
    // INTERNAL: Contract and children only
    function _incrementInternal() internal {
        data++;
    }
    
    // PRIVATE: Contract only
    function _doublePrivate() private {
        data *= 2;
    }
    
    // Public function that uses internal functions
    function process() public {
        _incrementInternal();
        _doublePrivate();
    }
    
    // VIEW: Read without gas cost
    function getData() public view returns (uint256) {
        return data;
    }
    
    // PURE: No state access
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
}
```

---

### Exercise 2.2: When to Use Each Type

**Scenario**: You're building a bank contract. Match the function to the appropriate visibility:

1. `calculateInterest()` - Helper function for interest calculation
2. `deposit()` - Users should be able to deposit
3. `_validateAmount()` - Internal validation, might be overridden by children
4. `getBalance()` - Check balance without gas cost
5. `_secretKey()` - Secret logic, never expose to children

**Answers**:
<details>
<summary>Click to reveal</summary>

1. `calculateInterest()` → `internal` or `private`
2. `deposit()` → `public` or `external`
3. `_validateAmount()` → `internal`
4. `getBalance()` → `public view`
5. `_secretKey()` → `private`

</details>

---

## ⚠️ Common Pitfalls

### 1. Forgetting Visibility Specifier

```solidity
// ❌ This won't compile - visibility is required!
function myFunction() {
    // ...
}

// ✅ Correct
function myFunction() public {
    // ...
}
```

### 2. Using `public` for Everything

```solidity
// ❌ Bad practice - exposes internal logic
function _calculateSecretKey() public pure returns (uint256) {
    return 42;
}

// ✅ Better - keep internal logic private
function _calculateSecretKey() private pure returns (uint256) {
    return 42;
}
```

### 3. Confusing `view` with State Changes

```solidity
// ❌ This won't compile - view can't modify state
function increment() public view {
    number++;  // ERROR!
}

// ✅ Correct
function increment() public {
    number++;
}

// ✅ Correct for view
function getNumber() public view returns (uint256) {
    return number;
}
```

### 4. Gas Costs Misunderstanding

From the transcription:
> *"gas fee gede itu depends on komputasi programmu"*

```solidity
// ❌ Expensive - loops and storage writes
function processArray(uint256[] memory arr) public {
    for (uint256 i = 0; i < arr.length; i++) {
        data[i] = arr[i];  // Storage write = expensive!
    }
}

// ✅ Cheaper - just calculation
function calculateSum(uint256[] memory arr) public pure returns (uint256) {
    uint256 sum = 0;
    for (uint256 i = 0; i < arr.length; i++) {
        sum += arr[i];  // Memory operation only
    }
    return sum;
}
```

---

## 📝 Self-Check Quiz

1. **Which visibility allows calls from both external users and inherited contracts?**
   <details><summary>Answer</summary>`public`</details>

2. **Can an `external` function be called internally?**
   <details><summary>Answer</summary>Only with `this.functionName()`, not directly</details>

3. **What's the difference between `view` and `pure`?**
   <details><summary>Answer</summary>`view` can read state, `pure` cannot read or modify state</details>

4. **Do `view` functions cost gas when called externally?**
   <details><summary>Answer</summary>No, they're free when called externally (off-chain)</details>

5. **Why prefix internal functions with `_`?**
   <details><summary>Answer</summary>Convention to indicate internal-only usage</details>

---

## 📚 Additional Resources

- **Solidity Docs**: [Function Visibility](https://docs.soliditylang.org/en/latest/contracts.html#function-visibility)
- **Solidity Docs**: [View Functions](https://docs.soliditylang.org/en/latest/contracts.html#view-functions)
- **CryptoZombies**: Lesson 3 (Functions & Visibility)
- **Cyfrin Updraft**: Function Visibility Best Practices

---

## 🎯 What's Next?

Now that you understand function visibility, move to **Module 3** where you'll learn about:
- Modifiers (`onlyOwner`, `whenPaused`)
- Custom errors vs `require`
- Constructors and initialization
- Access control patterns

**Ready?** → [Go to Module 3](../module-3/README.md)
