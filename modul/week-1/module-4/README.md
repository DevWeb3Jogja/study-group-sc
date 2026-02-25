# Module 4: Bytes & Encoding

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Understand the difference between `bytes`, `bytes32`, and `string`
- Use `abi.encode`, `abi.encodePacked`, and `abi.decode`
- Optimize gas costs with proper bytes usage
- Decode calldata for cross-chain messages
- Understand when to use bytes vs other data types

## 📚 Prerequisites

- Module 1: Solidity Basics & Data Types ✅
- Module 2: Functions & Visibility ✅
- Module 3: Modifiers & Access Control ✅

## ⏱️ Estimated Time

40-50 minutes

---

## 📖 Core Concepts

### 1. Bytes Types Overview

Solidity has several bytes-related types:

| Type | Size | Mutable | Use Case |
|------|------|---------|----------|
| `bytes` | Dynamic | ✅ Yes | Dynamic byte arrays |
| `bytes32` | Fixed (32 bytes) | ✅ Yes | Fixed-size data, hashes |
| `string` | Dynamic | ✅ Yes | Text data |
| `byte` | 1 byte | ✅ Yes | Single byte (deprecated, use `uint8`) |

From the transcription:
> *"bytes32 public name // bytes => 32 bytes"*

---

### 2. Why Use Bytes? (The Gas Optimization Story)

From the transcription:
> *"messagenya ini kalau misalnya dijadiin params ya, wah ini sizenya gede pak"*
> *"kalau dijadiin bytes dikirimnya, posisi bytes habis itu kita decode-nya kalau sudah mau kepakai"*

**The Problem:**
When you pass many parameters to a function, especially for cross-chain messages, it can be expensive:

```solidity
// ❌ Expensive: Many parameters
function sendMessage(
    address sender,
    address recipient,
    uint256 amount,
    uint256 timestamp,
    bytes32 hash,
    string memory message
) public {
    // ...
}
```

**The Solution:**
Encode everything into bytes, send as one parameter, decode when needed:

```solidity
// ✅ Cheaper: Single bytes parameter
function sendMessage(bytes calldata encodedData) public {
    // Decode only when needed
    (address sender, address recipient, uint256 amount) = 
        abi.decode(encodedData, (address, address, uint256));
}
```

---

### 3. Encoding Functions

#### **abi.encode()** - Padded Encoding

```solidity
bytes memory encoded = abi.encode(
    "Hello",
    address(0x123...),
    uint256(100)
);
```

**Characteristics:**
- ✅ Each value is padded to 32 bytes
- ✅ Includes type information
- ✅ Can be decoded with `abi.decode()`
- ❌ More expensive (due to padding)

**Use when:** You need to decode the data later on-chain.

---

#### **abi.encodePacked()** - Compact Encoding

```solidity
bytes memory encoded = abi.encodePacked(
    "Hello",
    address(0x123...),
    uint256(100)
);
```

**Characteristics:**
- ✅ No padding (tightly packed)
- ✅ Cheaper than `abi.encode()`
- ❌ Cannot be decoded (loses type information)
- ❌ Can have collision issues

**Use when:** 
- Creating hashes: `keccak256(abi.encodePacked(a, b))`
- When you don't need to decode

---

#### **abi.decode()** - Decoding

```solidity
bytes memory encoded = abi.encode("Hello", address(0x123...), 100);

// Decode back to original types
(string memory str, address addr, uint256 num) = 
    abi.decode(encoded, (string, address, uint256));
```

**Requirements:**
- ✅ Must know the exact types in order
- ✅ Must have been encoded with `abi.encode()` (not `encodePacked`)

---

### 4. Practical Example: Cross-Chain Messages

From the transcription:
> *"ini dienkripsi dulu messagenya, terus dikasih ke layer 0"*
> *"nah terus destination chain-nya bakal ini nge-decode ini"*

**Sender Chain:**
```solidity
// Encode the message
bytes memory payload = abi.encode(
    sender,
    recipient,
    amount,
    message
);

// Send to LayerZero (or other bridge)
lzEndpoint.send(
    dstChainId,
    abi.encodePacked(recipient),  // destination address
    payload,                       // encoded message
    address(0),                    // refund address
    address(0)                     // zro payment address
);
```

**Destination Chain:**
```solidity
function lzReceive(
    uint16 _srcChainId,
    bytes calldata _fromAddress,
    uint64 _nonce,
    bytes calldata _payload
) external {
    // Decode the message
    (address sender, address recipient, uint256 amount, string memory message) = 
        abi.decode(_payload, (address, address, uint256, string));
    
    // Process the message
    balances[recipient] += amount;
}
```

---

### 5. String vs Bytes32 vs Bytes

#### **When to use each:**

**`bytes32`** - Fixed-length data:
```solidity
bytes32 public name = "John";  // Efficient for short, fixed data
bytes32 public hash = keccak256(abi.encodePacked(data));
```

**`string`** - Variable-length text:
```solidity
string public message = "Hello, World!";
string public longDescription = "This is a longer text...";
```

**`bytes`** - Raw byte data:
```solidity
bytes public signature;  // Dynamic byte array
bytes public encodedData;
```

From the transcription:
> *"bytes itu karena dia makan memorynya dikit terus enak"*

**Gas Comparison** (approximate):
```solidity
// Storing "Hello" as:
bytes32  // ~32 gas (fixed, efficient)
string   // ~100+ gas (dynamic, overhead)
bytes    // ~80 gas (dynamic, less overhead than string)
```

---

### 6. Calldata vs Memory for Bytes

```solidity
// ❌ More expensive: Copies to memory
function processData(bytes memory data) public {
    // ...
}

// ✅ Cheaper: Uses calldata directly
function processData(bytes calldata data) public {
    // ...
}
```

**Key Difference:**
- `memory`: Creates a copy in memory (expensive)
- `calldata`: Reads directly from transaction data (cheaper, read-only)

**Use `calldata` for:**
- External/public function parameters
- When you don't need to modify the data

---

## 🔍 Code Walkthrough

Let's analyze `Week1_2.sol` bytes functionality:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_2 {
    bytes public encode;  // Dynamic byte array for storage

    /// @notice Encode a string and store as bytes
    /// @param _encode The string to encode
    function setBytesByString(string calldata _encode) public whenPaused {
        // abi.encode converts string to bytes with padding
        encode = abi.encode(_encode);
    }

    /// @notice Store bytes directly
    /// @param _encode The bytes to store
    function setBytesByBytes(bytes calldata _encode) public whenPaused {
        encode = _encode;
    }

    /// @notice Decode stored bytes back to string
    /// @return The decoded string
    function decodeBytesToString() public view whenPaused returns (string memory) {
        // abi.decode converts bytes back to original type
        return abi.decode(encode, (string));
    }
}
```

### Key Points:

1. **`bytes calldata`** for function parameters (gas efficient)
2. **`bytes public`** for storage (dynamic size)
3. **`abi.encode()`** to convert string → bytes
4. **`abi.decode()`** to convert bytes → string
5. **`string memory`** return type (needs to be in memory)

---

## 🛠️ Hands-On Exercises

### Exercise 4.1: Basic Encoding/Decoding

**Task**: Create a contract that encodes and decodes various data types.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Encoder {
    bytes public storedData;
    
    function encodeData(
        string memory text,
        address addr,
        uint256 number
    ) public pure returns (bytes memory) {
        return abi.encode(text, addr, number);
    }
    
    function decodeData(bytes calldata data) 
        public 
        pure 
        returns (string memory, address, uint256) 
    {
        return abi.decode(data, (string, address, uint256));
    }
    
    function storeEncoded(
        string memory text,
        address addr,
        uint256 number
    ) public {
        storedData = abi.encode(text, addr, number);
    }
    
    function getStoredData() 
        public 
        view 
        returns (string memory, address, uint256) 
    {
        return abi.decode(storedData, (string, address, uint256));
    }
}
```

---

### Exercise 4.2: Hash Comparison

**Task**: Demonstrate the difference between `encode` and `encodePacked` for hashing.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract HashComparison {
    function hashWithEncode(string memory a, string memory b) 
        public 
        pure 
        returns (bytes32) 
    {
        return keccak256(abi.encode(a, b));
    }
    
    function hashWithEncodePacked(string memory a, string memory b) 
        public 
        pure 
        returns (bytes32) 
    {
        return keccak256(abi.encodePacked(a, b));
    }
    
    // Notice: encodePacked is cheaper but can have collisions
}
```

---

## ⚠️ Common Pitfalls

### 1. Trying to Decode encodePacked

```solidity
// ❌ This won't work!
bytes memory encoded = abi.encodePacked("Hello", uint256(100));
(string memory str, uint256 num) = abi.decode(encoded, (string, uint256));
// Reverts! encodePacked loses type information

// ✅ Correct
bytes memory encoded = abi.encode("Hello", uint256(100));
(string memory str, uint256 num) = abi.decode(encoded, (string, uint256));
```

### 2. Collision with encodePacked

```solidity
// ❌ Dangerous: Can have collisions
string a = "AB";
string b = "C";
string c = "A";
string d = "BC";

keccak256(abi.encodePacked(a, b)) == keccak256(abi.encodePacked(c, d));
// Both produce "ABC" when packed!

// ✅ Safe: Use abi.encode()
keccak256(abi.encode(a, b)) != keccak256(abi.encode(c, d));
```

### 3. Wrong Decode Types

```solidity
// ❌ Wrong order
bytes memory encoded = abi.encode("Hello", 100);
(uint256 num, string memory str) = abi.decode(encoded, (uint256, string));
// Reverts! Order must match

// ✅ Correct
(string memory str, uint256 num) = abi.decode(encoded, (string, uint256));
```

---

## 📝 Self-Check Quiz

1. **What's the difference between `abi.encode()` and `abi.encodePacked()`?**
   <details><summary>Answer</summary>`encode()` pads to 32 bytes and includes type info (decodable). `encodePacked()` is tightly packed (not decodable).</details>

2. **Can you decode data encoded with `abi.encodePacked()`?**
   <details><summary>Answer</summary>No, type information is lost</details>

3. **Which is more gas-efficient: `bytes memory` or `bytes calldata` for function parameters?**
   <details><summary>Answer</summary>`bytes calldata` - no copying to memory</details>

4. **When would you use `bytes32` instead of `string`?**
   <details><summary>Answer</summary>For fixed-length data, hashes, or when gas efficiency is critical</details>

5. **Why encode multiple parameters into bytes?**
   <details><summary>Answer</summary>For cross-chain messages, reducing function parameters, gas optimization</details>

---

## 📚 Additional Resources

- **Solidity Docs**: [Units and Global Variables](https://docs.soliditylang.org/en/latest/units-and-global-variables.html)
- **Solidity Docs**: [ABI Encoding](https://docs.soliditylang.org/en/latest/abi-spec.html)
- **Swiss Knife**: [Calldata Decoder](https://calldata.swiss-knife.xyz/) - Tool mentioned in transcription
- **LayerZero Docs**: Cross-chain message encoding

---

## 🎯 What's Next?

Now that you understand bytes and encoding, move to **Module 5** where you'll learn about:
- Structs for complex data structures
- Enums for state management
- Mappings for efficient data storage
- Arrays (dynamic and fixed)

**Ready?** → [Go to Module 5](../module-5/README.md)
