# Module 4: Quiz

Test your understanding of Bytes & Encoding.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers (60/75 points)
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (5 points)

**Which encoding function should you use if you need to decode the data later?**

A) `abi.encodePacked()`  
B) `abi.encode()`  
C) `keccak256()`  
D) `bytes.concat()`  

<details><summary>Answer</summary>B) `abi.encode()`</details>

---

### 2. Multiple Choice (5 points)

**What is the main advantage of `bytes calldata` over `bytes memory` for function parameters?**

A) It can be modified  
B) It's more gas-efficient (no copying)  
C) It can store more data  
D) It's easier to decode  

<details><summary>Answer</summary>B) It's more gas-efficient (no copying)</details>

---

### 3. True/False (5 points)

**You can decode data that was encoded with `abi.encodePacked()`.**

<details><summary>Answer</summary>False - `encodePacked` loses type information and cannot be decoded</details>

---

### 4. True/False (5 points)

**`bytes32` is more gas-efficient than `string` for storing fixed-length short text.**

<details><summary>Answer</summary>True</details>

---

### 5. Multiple Choice (5 points)

**Why encode multiple parameters into a single `bytes` parameter for cross-chain messages?**

A) To make the code more complex  
B) To reduce the number of parameters and optimize gas  
C) Because Solidity requires it  
D) To prevent decoding  

<details><summary>Answer</summary>B) To reduce the number of parameters and optimize gas</details>

---

### 6. Multiple Choice (5 points)

**What happens if you try to decode bytes with the wrong type order?**

A) It returns default values  
B) It compiles but gives wrong results  
C) The transaction reverts  
D) It automatically corrects the types  

<details><summary>Answer</summary>C) The transaction reverts</details>

---

### 7. Short Answer (10 points)

**Explain the collision risk with `abi.encodePacked()`. Give an example.**

<details>
<summary>Answer</summary>

`abi.encodePacked()` concatenates data without padding, which can cause different inputs to produce the same output.

Example:
```solidity
abi.encodePacked("AB", "C")  // Produces: "ABC"
abi.encodePacked("A", "BC")  // Also produces: "ABC"
```

Both produce the same bytes, causing a collision when hashed.

</details>

---

### 8. Code Analysis (10 points)

**What's wrong with this code?**

```solidity
function processData(bytes memory data) public {
    // Process data
}

function encodeAndStore(string memory text) public {
    bytes memory encoded = abi.encodePacked(text);
    processData(encoded);
}
```

<details>
<summary>Answer</summary>

1. Should use `bytes calldata` instead of `bytes memory` for the parameter (gas optimization)
2. Using `encodePacked` means the data cannot be decoded later if needed
3. Should use `abi.encode()` if decoding might be needed

Better:
```solidity
function processData(bytes calldata data) public {
    // Process data
}

function encodeAndStore(string memory text) public {
    bytes memory encoded = abi.encode(text);
    processData(encoded);
}
```

</details>

---

### 9. Practical (15 points)

**Write a contract with:**
- A function that encodes (address, uint256, string) into bytes
- A function that decodes bytes back to those types
- A function that stores encoded data
- Use appropriate data types (calldata vs memory)

<details>
<summary>Answer</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Encoder {
    bytes public storedData;
    
    function encode(
        address addr,
        uint256 number,
        string memory text
    ) public pure returns (bytes memory) {
        return abi.encode(addr, number, text);
    }
    
    function decode(bytes calldata data) 
        public 
        pure 
        returns (address, uint256, string memory) 
    {
        return abi.decode(data, (address, uint256, string));
    }
    
    function store(address addr, uint256 number, string memory text) public {
        storedData = abi.encode(addr, number, text);
    }
    
    function retrieve() 
        public 
        view 
        returns (address, uint256, string memory) 
    {
        return abi.decode(storedData, (address, uint256, string));
    }
}
```

</details>

---

### 10. Gas Optimization (10 points)

**Rank these from most to least gas-efficient for function parameters:**

1. `bytes memory`
2. `bytes calldata`
3. `string memory`
4. `bytes32`

<details>
<summary>Answer</summary>

Most to least efficient:
1. `bytes32` (fixed size, no overhead)
2. `bytes calldata` (no copying)
3. `bytes memory` (requires copying)
4. `string memory` (additional string overhead)

</details>

---

### 11. Use Case Matching (10 points)

**Match the use case to the best encoding method:**

1. Creating a hash for a signature  
2. Encoding data for cross-chain transfer  
3. Storing a username (max 20 chars)  
4. Encoding data that needs to be decoded later  

Options: `abi.encode()`, `abi.encodePacked()`, `bytes32`, `string`

<details>
<summary>Answer</summary>

1. Creating a hash for signature → `abi.encodePacked()` (cheaper, no decode needed)
2. Encoding data for cross-chain transfer → `abi.encode()` (needs decoding on destination)
3. Storing a username → `bytes32` (fixed size, efficient)
4. Encoding data to decode later → `abi.encode()` (preserves type info)

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 65-75 | Excellent | Ready for Module 5! |
| 55-64 | Good | Review weak areas, then continue |
| 45-54 | Fair | Review README and exercises |
| <45 | Needs Work | Re-study Module 4 thoroughly |

---

## Answer Sheet

Write your answers here before checking:

1. ___
2. ___
3. ___
4. ___
5. ___
6. ___
7. ___
8. ___
9. ___
10. ___
11. ___

---

**Scored 55+?** → [Continue to Module 5](../module-5/README.md)  
**Scored <55?** → Review [Module 4 README](README.md) and retry exercises
