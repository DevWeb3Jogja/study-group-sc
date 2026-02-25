# Module 1: Solidity Basics & Data Types

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Understand Solidity's primitive data types
- Declare and use state variables
- Differentiate between value types and reference types
- Choose appropriate data types for your use case
- Read and understand the basic structure of a Solidity contract

## 📚 Prerequisites

- Basic programming knowledge (variables, data types)
- Familiarity with blockchain concepts (what is a smart contract)
- Foundry installed and working

## ⏱️ Estimated Time

30-45 minutes

---

## 📖 Core Concepts

### 1. What are State Variables?

**State variables** are permanently stored data in your smart contract. Unlike local variables that exist only during function execution, state variables persist on the blockchain.

From the transcription:
> *"jadi diatas ini namanya state variabel"*

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;        // State variable
    address public owner;         // State variable
    bytes32 public name;          // State variable
}
```

### 2. Primitive Data Types

#### **uint256** - Unsigned Integers
- Stores **non-negative** numbers (≥ 0)
- Size: 256 bits (can also use uint8, uint32, uint64, etc.)
- Default value: `0`

```solidity
uint256 public number = 100;  // Can store 0, 1, 2, 3, ... up to 2^256 - 1
uint256 public balance = 0;   // Default value
```

⚠️ **Important**: Cannot store negative numbers. If you try `number--` when `number` is 0, it will **revert** (underflow error in Solidity 0.8+).

#### **int256** - Signed Integers
- Stores **positive and negative** numbers
- Range: -2^256 to 2^256 - 1
- Default value: `0`

```solidity
int256 public number2 = -50;  // Can store negative values
int256 public temperature = 25;
```

From the transcription:
> *"int256 public number2 // n >= -2^256 and n <= 2^256 - 1"*

#### **address** - Ethereum Addresses
- Stores Ethereum addresses (20 bytes, 40 hex characters)
- Used for wallet addresses and contract addresses
- Default value: `0x0000000000000000000000000000000000000000`

```solidity
address public owner;  // Typically set in constructor
address public userWallet = 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb;
```

From the transcription:
> *"address itu Id user yang unik gitu loh, bisa user bisa kontrak"*

#### **bytes32** - Fixed-size Byte Arrays
- Stores exactly 32 bytes of data
- More gas-efficient than `string` for fixed-length data
- Default value: `0x0000000000000000000000000000000000000000000000000000000000000000`

```solidity
bytes32 public name = "John";  // Stored as fixed 32 bytes
bytes32 public hash = keccak256(abi.encodePacked("data"));
```

⚠️ **Memory Limit**: From the transcription:
> *"maksimal memori size code around 24 KB"*

This is why contract size is limited - you need to be mindful of storage.

#### **bool** - Boolean Values
- Stores `true` or `false`
- Default value: `false`

```solidity
bool public isActive = true;
bool public isStudent = false;
```

#### **string** - Dynamic Text
- Stores variable-length text
- More expensive than `bytes32` for fixed data
- Default value: `""` (empty string)

```solidity
string public message = "Hello, World!";
string public name = "Alice";
```

---

## 🔍 Code Walkthrough

Let's analyze `Counter.sol` line by line:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;  // Compiler version

contract Counter {
    // uint256: unsigned integer, can only store positive numbers (including 0)
    uint256 public number; // n >= 0, size: 256 bits
    
    // int256: signed integer, can store negative numbers
    int256 public number2; // -2^256 <= n <= 2^256 - 1
    
    // mapping: key-value store (like a dictionary/hashmap)
    // address => uint256 means: each address maps to a uint256 value
    mapping(address => uint256) public numbers;
    
    // Dynamic array of uint256
    uint256[] public numbersArray;
    
    // Address type for storing wallet/contract addresses
    address public owner;
    
    // Fixed-size byte array (32 bytes)
    bytes32 public name;
    
    // Struct: custom data type grouping multiple variables
    struct Person {
        string name;
        uint256 age;
        bool isStudent;
    }
    
    Person public person;  // Instance of Person struct
    
    // Enum: custom type with predefined named values
    enum Status {
        Pending,     // 0
        Completed,   // 1
        Failed       // 2
    }
    
    Status public status;  // Instance of Status enum
    
    // ... functions below
}
```

---

## 🛠️ Hands-On Exercises

### Exercise 1.1: Basic Variable Declaration

**Task**: Create a new contract called `Profile.sol` in `src/week1/` with the following state variables:
- `age` (uint256) - your age
- `balance` (int256) - can be negative for debt
- `walletAddress` (address) - your wallet address
- `username` (bytes32) - your username
- `isActive` (bool) - whether the profile is active

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Profile {
    uint256 public age = 25;
    int256 public balance = -100;
    address public walletAddress = 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb;
    bytes32 public username = "alice";
    bool public isActive = true;
}
```

### Exercise 1.2: Understanding Default Values

**Task**: Create a contract `Defaults.sol` that declares variables of each type **without** initializing them. Then create a test to verify their default values.

**Hint**: Use `console.log` in your test to see the values.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Defaults {
    uint256 public myUint;
    int256 public myInt;
    address public myAddress;
    bytes32 public myBytes;
    bool public myBool;
    string public myString;
}
```

```solidity
// Test file
function testDefaultValues() public {
    Defaults defaults = new Defaults();
    
    console.log("uint256 default:", defaults.myUint());      // 0
    console.log("int256 default:", defaults.myInt());        // 0
    console.log("address default:", defaults.myAddress());   // 0x000...
    console.log("bool default:", defaults.myBool());         // false
    console.log("string default:", defaults.myString());     // ""
}
```

### Exercise 1.3: Mapping Practice

**Task**: Create a `Voting.sol` contract with:
- A mapping that tracks votes per address (`mapping(address => uint256)`)
- A function to cast a vote
- A function to get vote count for an address

---

## ⚠️ Common Pitfalls

### 1. Underflow/Overflow
In Solidity 0.8+, arithmetic operations automatically check for overflow/underflow:

```solidity
uint256 public number = 0;
number--;  // ❌ This will REVERT (underflow)
```

From the transcription:
> *"ini gak bisa negatif, udah kita tambahin aja"*

### 2. Gas Costs with Large Data
Storing large amounts of data is expensive:

```solidity
// ❌ Expensive for large datasets
uint256[] public hugeArray;

// ✅ Better for large datasets
mapping(uint256 => uint256) public dataById;
```

### 3. Address vs bytes20
While an address is technically 20 bytes, use `address` type for wallet addresses:

```solidity
address public user = 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb;  // ✅
bytes20 public user = 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb;  // ❌ Wrong type
```

---

## 📝 Self-Check Quiz

1. **What is the default value of `uint256`?**
   <details><summary>Answer</summary>0</details>

2. **Can `uint256` store negative numbers?**
   <details><summary>Answer</summary>No, only non-negative numbers (≥ 0)</details>

3. **What's the difference between `bytes32` and `string`?**
   <details><summary>Answer</summary>`bytes32` is fixed-size (32 bytes), `string` is dynamic-length. `bytes32` is more gas-efficient for fixed data.</details>

4. **What happens if you try to decrement a `uint256` with value 0?**
   <details><summary>Answer</summary>The transaction will revert due to underflow protection in Solidity 0.8+</details>

5. **What type would you use to store an Ethereum wallet address?**
   <details><summary>Answer</summary>`address`</details>

---

## 📚 Additional Resources

- **Solidity Docs**: [Types](https://docs.soliditylang.org/en/latest/types.html)
- **CryptoZombies**: Lesson 1-2 (Basic Types)
- **Cyfrin Updraft**: Solidity Fundamentals
- **Tools**: [Swiss Knife - Calldata Decoder](https://calldata.swiss-knife.xyz/)

---

## 🎯 What's Next?

Now that you understand data types, move to **Module 2** where you'll learn about:
- Function visibility (public, external, internal, private)
- View functions that don't cost gas
- How to structure functions properly

**Ready?** → [Go to Module 2](../module-2/README.md)
