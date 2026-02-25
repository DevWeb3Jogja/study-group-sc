# Module 1: Quiz

Test your understanding of Solidity Basics & Data Types.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers before moving to Module 2
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (3 points)

**What is the default value of `uint256` in Solidity?**

A) -1  
B) 0  
C) 1  
D) null  

<details><summary>Answer</summary>B) 0</details>

---

### 2. Multiple Choice (3 points)

**Which data type would you use to store a wallet address?**

A) bytes20  
B) string  
C) address  
D) bytes32  

<details><summary>Answer</summary>C) address</details>

---

### 3. True/False (3 points)

**`int256` can store negative numbers.**

<details><summary>Answer</summary>True</details>

---

### 4. True/False (3 points)

**`uint256` can store values from -2^256 to 2^256 - 1.**

<details><summary>Answer</summary>False - uint256 can only store non-negative numbers (0 to 2^256 - 1)</details>

---

### 5. Multiple Choice (3 points)

**What happens when you try to decrement a `uint256` with value 0 in Solidity 0.8+?**

A) It wraps around to the maximum uint256 value  
B) It becomes -1  
C) The transaction reverts  
D) It becomes 0  

<details><summary>Answer</summary>C) The transaction reverts</details>

---

### 6. Short Answer (5 points)

**Explain the difference between `bytes32` and `string`. When would you use each?**

<details>
<summary>Answer</summary>

- `bytes32` is a fixed-size byte array (exactly 32 bytes)
- `string` is a dynamic-length byte array for text
- Use `bytes32` for fixed-length data (more gas-efficient)
- Use `string` for variable-length text data

</details>

---

### 7. Code Reading (5 points)

**What will be the output of this code?**

```solidity
contract Test {
    uint256 public a = 10;
    uint256 public b;
    
    function getValue() public view returns (uint256) {
        return a + b;
    }
}
```

What does `getValue()` return?

<details><summary>Answer</summary>10 (because b defaults to 0, so 10 + 0 = 10)</details>

---

### 8. Code Analysis (5 points)

**Identify the issue in this code:**

```solidity
contract Problem {
    uint256 public count = 0;
    
    function decrease() public {
        count--;
    }
}
```

What happens when `decrease()` is called?

<details><summary>Answer</summary>The transaction will revert due to underflow (can't go below 0 with uint256)</details>

---

### 9. Practical (10 points)

**Write a contract that:**
- Has a public `uint256` variable called `score`
- Has a public `address` variable called `player`
- Has a function `setScore(uint256 _score)` that sets the score
- Has a function `setPlayer(address _player)` that sets the player address

<details>
<summary>Answer</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Game {
    uint256 public score;
    address public player;
    
    function setScore(uint256 _score) public {
        score = _score;
    }
    
    function setPlayer(address _player) public {
        player = _player;
    }
}
```

</details>

---

### 10. Conceptual (10 points)

**Why is the maximum contract size limited to approximately 24 KB in Ethereum?**

<details>
<summary>Answer</summary>

The 24 KB limit exists to:
- Prevent bloated contracts that are hard to audit
- Reduce gas costs for contract deployment and execution
- Improve network performance by limiting state bloat
- Encourage modular design with multiple smaller contracts

</details>

---

### 11. Mapping Understanding (10 points)

**Given this code:**

```solidity
mapping(address => uint256) public balances;
```

1. What is the default value for a new address that hasn't been set?
2. How would you access the balance of address `0x123...`?

<details>
<summary>Answer</summary>

1. The default value is 0
2. `balances[0x123...]` or call the auto-generated getter `balances(0x123...)`

</details>

---

### 12. Best Practices (10 points)

**You need to store usernames for 10,000 users. Each username is max 20 characters. Would you use:**

A) `string[]` (array of strings)  
B) `mapping(address => string)`  
C) `mapping(address => bytes32)`  

Explain your choice.

<details>
<summary>Answer</summary>

**B) `mapping(address => string)`** is the best choice because:
- Mappings are more gas-efficient for lookups than arrays
- Strings allow variable-length usernames (not all are 20 chars)
- Each user is identified by their address
- Easy to add/remove users

C could work but wastes space for short usernames.  
A is inefficient for lookups and doesn't associate usernames with addresses.

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 60-70 | Excellent | Ready for Module 2! |
| 50-59 | Good | Review weak areas, then continue |
| 40-49 | Fair | Review README and exercises |
| <40 | Needs Work | Re-study Module 1 thoroughly |

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
12. ___

---

**Scored 50+?** → [Continue to Module 2](../module-2/README.md)  
**Scored <50?** → Review [Module 1 README](README.md) and retry exercises
