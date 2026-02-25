# Module 3: Modifiers & Access Control

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Understand and create custom modifiers
- Implement access control patterns (`onlyOwner`, `whenPaused`)
- Use custom errors instead of `require` for gas optimization
- Write and use constructors for initialization
- Apply the "checks-effects-interactions" pattern

## 📚 Prerequisites

- Module 1: Solidity Basics & Data Types ✅
- Module 2: Functions & Visibility ✅
- Understanding of state variables and functions

## ⏱️ Estimated Time

40-50 minutes

---

## 📖 Core Concepts

### 1. What are Modifiers?

**Modifiers** are reusable pieces of code that run **before** (and/or after) a function executes. They're like guards that check conditions before allowing function execution.

From the transcription:
> *"life changing banget, kita gak perlu ngeset setiap ini if, langsung aja taruh sini only owner"*
> *"jadi jadinya enggak kotor gitu lho kodenya"*

This is the power of modifiers - **clean, reusable access control**!

### Basic Modifier Syntax

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;  // This is where the function body will be inserted
}

function withdraw() public onlyOwner {
    // This code runs AFTER the modifier check passes
    payable(owner).transfer(address(this).balance);
}
```

The `_` (underscore) is a placeholder that represents **where the function's code will be inserted**.

---

### 2. How Modifiers Work (Step by Step)

Let's trace through what happens:

```solidity
modifier onlyOwner() {
    // Step 1: Check condition
    require(msg.sender == owner, "Not owner");
    
    // Step 2: Execute function body (represented by _)
    _;
    
    // Step 3: (Optional) Code after _ runs after function completes
}

function changeSetting(uint256 newValue) public onlyOwner {
    // This is inserted at the _ position
    setting = newValue;
}
```

**Execution flow:**
1. User calls `changeSetting()`
2. Modifier checks: `msg.sender == owner`?
3. If ✅ YES → Execute function body at `_`
4. If ❌ NO → Revert with "Not owner"

---

### 3. Common Modifier Patterns

#### **onlyOwner** - Owner-Only Access

```solidity
address public owner;

modifier onlyOwner() {
    _onlyOwner();
    _;
}

function _onlyOwner() internal view {
    require(msg.sender == owner, "You are not the owner");
}
```

From the transcription:
> *"kita cukup ngasih modifier, ya udah satu level sama function sebelum masuk ke function jadi protect dulu di only owner"*

**Usage:**
```solidity
function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
}
```

---

#### **whenPaused / whenNotPaused** - Circuit Breaker Pattern

```solidity
enum IsPaused {
    Paused,     // 0
    Unpaused    // 1
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

function _whenPaused() internal view {
    require(isPaused == IsPaused.Paused, "Contract is not paused");
}

function _whenNotPaused() internal view {
    require(isPaused == IsPaused.Unpaused, "Contract is paused");
}
```

**Why use this pattern?**

From the transcription:
> *"kita udah ketahuan ada vulnerability di sini, kita harus segera pause. Orang-orang udah gak bisa apa-apa"*

When you discover a bug or exploit, you can **pause the contract** to prevent further damage while you fix it.

**Usage:**
```solidity
function deposit() public whenNotPaused {
    balances[msg.sender] += msg.value;
}

function emergencyWithdraw() public whenPaused {
    // Allow withdrawals even when paused
    payable(msg.sender).transfer(balances[msg.sender]);
}
```

---

#### **userExist** - Custom Validation

```solidity
mapping(address => User) public user;

modifier userExist() {
    _userExist();
    _;
}

function _userExist() internal view {
    if (user[msg.sender].id != 0) revert UserExist();
}
```

**Usage:**
```solidity
function addUser(string calldata name) public userExist {
    // Only users who don't exist can call this
    user[msg.sender] = User({id: 1, name: name});
}
```

---

### 4. Custom Errors vs `require`

#### **Old Way: require with strings**

```solidity
function withdraw() public {
    require(msg.sender == owner, "You are not the owner");
}
```

**Problems:**
- ❌ Stores string in bytecode (expensive!)
- ❌ Harder to handle programmatically

#### **New Way: Custom Errors**

```solidity
error NotOwner();
error ContractIsPaused();

function withdraw() public {
    if (msg.sender != owner) revert NotOwner();
}
```

From the transcription:
> *"require makan gas lebih banyak, dan FYI kalau revert terus pakai string itu juga banyak"*
> *"better kalau ada revert kita bikin error handling disini"*

**Benefits:**
- ✅ Much cheaper gas (no string storage)
- ✅ Can be caught and handled programmatically
- ✅ Cleaner code

---

### 5. Constructors

A **constructor** is a special function that runs **once** when the contract is deployed.

```solidity
address public owner;

constructor() {
    owner = msg.sender;  // Deployer becomes owner
}
```

From the transcription:
> *"kalau dikontrak pertama kali kita deploy, dia akan execute konstruktor"*
> *"pokoknya yang pertama kali execute konstruktor ini bisa kita sendiri"*

**Key Points:**
- ✅ Runs **only once** at deployment
- ✅ Cannot be called after deployment
- ✅ Used for initialization
- ✅ No `function` keyword

---

### 6. Modifier Best Practices

#### **Split Logic into Internal Functions**

```solidity
// ✅ GOOD: Clean and reusable
modifier onlyOwner() {
    _onlyOwner();
    _;
}

function _onlyOwner() internal view {
    if (msg.sender != owner) revert NotOwner();
}

// ❌ BAD: Logic inside modifier
modifier onlyOwner() {
    if (msg.sender != owner) revert NotOwner();
    _;
}
```

From the transcription:
> *"aku lebih seneng begini jadi dia masuk ke internal function"*

**Why?**
- Internal functions can be tested independently
- Cleaner modifier syntax
- Easier to override in child contracts

---

### 7. Multiple Modifiers

You can stack multiple modifiers on one function:

```solidity
function withdraw() public onlyOwner whenNotPaused {
    payable(owner).transfer(address(this).balance);
}
```

**Execution order:**
1. `onlyOwner` check
2. `whenNotPaused` check
3. Function body

---

## 🔍 Code Walkthrough

Let's analyze `Week1_2.sol`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_2 {
    // Custom errors (gas-efficient!)
    error NotOwner();
    error ContractIsPaused();

    // Events for off-chain tracking
    event SetBytesByString(string _encode);
    event SetBytesByBytes(bytes _encode);

    bytes public encode;      // Stored encoded data
    address public owner;     // Contract owner

    // Enum for pause state
    enum IsPaused {
        Paused,     // 0
        Unpaused    // 1
    }

    IsPaused public isPaused;

    // Modifier: Only allows when paused
    modifier whenPaused() {
        _whenPaused();
        _;
    }

    // Modifier: Only owner can access
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    // Constructor: Runs once at deployment
    constructor() {
        owner = msg.sender;  // Deployer becomes owner
    }

    // These functions only work when contract is paused
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

    // Owner-only functions
    function pause() public onlyOwner {
        isPaused = IsPaused.Paused;
    }

    function unpause() public onlyOwner {
        isPaused = IsPaused.Unpaused;
    }

    // Internal validation functions
    function _whenPaused() internal view {
        if (isPaused == IsPaused.Paused) revert ContractIsPaused();
    }

    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }
}
```

### Key Patterns:

1. **Custom Errors**: `NotOwner()`, `ContractIsPaused()`
2. **Modifier Pattern**: `onlyOwner()`, `whenPaused()`
3. **Internal Validation**: `_onlyOwner()`, `_whenPaused()`
4. **Constructor**: Sets initial owner
5. **Enum State**: `IsPaused` for clear state management

---

## 🛠️ Hands-On Exercises

### Exercise 3.1: Create Your Own Modifier

**Task**: Create a `MaxValueModifier.sol` contract with a modifier that ensures a value doesn't exceed a maximum.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract MaxValueModifier {
    error ExceedsMaxValue(uint256 value, uint256 max);
    
    uint256 public maxValue = 1000;
    uint256 public currentValue = 0;
    
    modifier maxValueCheck(uint256 value) {
        _maxValueCheck(value);
        _;
    }
    
    function _maxValueCheck(uint256 value) internal view {
        if (value > maxValue) {
            revert ExceedsMaxValue(value, maxValue);
        }
    }
    
    function setValue(uint256 _value) public maxValueCheck(_value) {
        currentValue = _value;
    }
    
    function setMaxValue(uint256 _max) public {
        maxValue = _max;
    }
}
```

---

### Exercise 3.2: Emergency Pause System

**Task**: Implement a complete pause system for a token contract.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract PausableToken {
    error NotOwner();
    error ContractPaused();
    
    mapping(address => uint256) public balances;
    address public owner;
    bool public paused = false;
    
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }
    
    modifier whenNotPaused() {
        _whenNotPaused();
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function transfer(address to, uint256 amount) public whenNotPaused {
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    function pause() public onlyOwner {
        paused = true;
    }
    
    function unpause() public onlyOwner {
        paused = false;
    }
    
    function _onlyOwner() internal view {
        if (msg.sender != owner) revert NotOwner();
    }
    
    function _whenNotPaused() internal view {
        if (paused) revert ContractPaused();
    }
}
```

---

## ⚠️ Common Pitfalls

### 1. Forgetting the Underscore

```solidity
// ❌ WRONG: Function body never executes!
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
}

// ✅ CORRECT
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

### 2. Modifier with State Changes

```solidity
// ❌ BAD: Modifiers should validate, not change state
modifier incrementCounter() {
    counter++;
    _;
}

// ✅ GOOD: Keep state changes in functions
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

### 3. Reentrancy in Modifiers

```solidity
// ❌ DANGEROUS: Code after _ can be affected by reentrancy
modifier safeTransfer() {
    _;
    balance -= amount;  // Executed AFTER function, might be unsafe
}

// ✅ SAFE: Checks before _
modifier safeTransfer() {
    require(balance >= amount, "Insufficient");
    _;
}
```

---

## 📝 Self-Check Quiz

1. **What does the `_` represent in a modifier?**
   <details><summary>Answer</summary>The placeholder where the function body will be inserted</details>

2. **When does a constructor execute?**
   <details><summary>Answer</summary>Only once, when the contract is deployed</details>

3. **Why are custom errors more gas-efficient than `require` with strings?**
   <details><summary>Answer</summary>They don't store error messages in bytecode</details>

4. **Can a function have multiple modifiers?**
   <details><summary>Answer</summary>Yes, they execute in order</details>

5. **What's the purpose of the `whenPaused` modifier?**
   <details><summary>Answer</summary>To restrict function access during emergencies/maintenance</details>

---

## 📚 Additional Resources

- **Solidity Docs**: [Modifiers](https://docs.soliditylang.org/en/latest/contracts.html#function-modifiers)
- **Solidity Docs**: [Custom Errors](https://docs.soliditylang.org/en/latest/contracts.html#errors)
- **OpenZeppelin**: [Ownable](https://docs.openzeppelin.com/contracts/4.x/access-control)
- **Cyfrin Updraft**: Access Control Best Practices

---

## 🎯 What's Next?

Now that you understand modifiers and access control, move to **Module 4** where you'll learn about:
- Bytes encoding and decoding
- `abi.encode` vs `abi.encodePacked`
- Gas optimization with bytes
- When to use bytes vs string

**Ready?** → [Go to Module 4](../module-4/README.md)
