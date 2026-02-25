# Module 2: Quiz

Test your understanding of Functions & Visibility.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers (60/75 points)
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (5 points)

**Which visibility specifier allows a function to be called by anyone (external users, other contracts, and inherited contracts)?**

A) external  
B) internal  
C) public  
D) private  

<details><summary>Answer</summary>C) public</details>

---

### 2. Multiple Choice (5 points)

**Can an `external` function be called internally within the same contract?**

A) Yes, always  
B) No, never  
C) Only with `this.functionName()`  
D) Only in the constructor  

<details><summary>Answer</summary>C) Only with `this.functionName()`</details>

---

### 3. True/False (5 points)

**A `view` function can modify state variables.**

<details><summary>Answer</summary>False - view functions can only read state, not modify it</details>

---

### 4. True/False (5 points)

**A `pure` function costs no gas when called externally.**

<details><summary>Answer</summary>True - pure functions don't access state, so they're free when called externally</details>

---

### 5. Multiple Choice (5 points)

**Which visibility is most appropriate for a helper function that should only be used within the contract and its children?**

A) public  
B) external  
C) internal  
D) private  

<details><summary>Answer</summary>C) internal</details>

---

### 6. Multiple Choice (5 points)

**What happens if you forget to specify function visibility?**

A) It defaults to public  
B) It defaults to private  
C) The code won't compile  
D) It defaults to external  

<details><summary>Answer</summary>C) The code won't compile - visibility is required</details>

---

### 7. Short Answer (10 points)

**Explain the difference between `view` and `pure` functions. Give one example of each.**

<details>
<summary>Answer</summary>

- `view`: Can read state variables but cannot modify them
  - Example: `function getBalance() public view returns (uint256)`
  
- `pure`: Cannot read or modify state variables, only uses parameters
  - Example: `function add(uint256 a, uint256 b) public pure returns (uint256)`

</details>

---

### 8. Code Analysis (10 points)

**Identify the visibility of each function and who can call them:**

```solidity
contract Example {
    uint256 public data;
    
    function func1() public { }
    function func2() external { }
    function _func3() internal { }
    function _func4() private { }
}
```

<details>
<summary>Answer</summary>

- `func1()`: public - anyone can call (external users, contracts, children)
- `func2()`: external - only external calls (not internally without `this.`)
- `_func3()`: internal - contract itself and child contracts
- `_func4()`: private - only the contract itself

</details>

---

### 9. Practical (15 points)

**Write a contract with:**
- A state variable `uint256 public score`
- A `public` function to set the score
- An `external` function to reset the score to 0
- An `internal` function that doubles the score
- A `private` function that validates the score is positive
- A `view` function that returns if the score is above 100

<details>
<summary>Answer</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Game {
    uint256 public score;
    
    function setScore(uint256 _score) public {
        require(_isValid(_score), "Invalid score");
        score = _score;
    }
    
    external function resetScore() external {
        score = 0;
    }
    
    function _doubleScore() internal {
        score *= 2;
    }
    
    function _isValid(uint256 _score) private pure returns (bool) {
        return _score > 0;
    }
    
    function isAbove100() public view returns (bool) {
        return score > 100;
    }
}
```

</details>

---

### 10. Scenario-Based (10 points)

**You're building an NFT marketplace. Match each function to the appropriate visibility:**

1. `buyNFT()` - Users buy NFTs
2. `_calculateRoyalty()` - Internal royalty calculation, may be overridden by children
3. `getNFTInfo()` - Read NFT metadata without gas cost
4. `_secretAlgorithm()` - Proprietary pricing, never expose to children
5. `listNFT()` - Users list their NFTs for sale

<details>
<summary>Answer</summary>

1. `buyNFT()` → `public` or `external`
2. `_calculateRoyalty()` → `internal`
3. `getNFTInfo()` → `public view`
4. `_secretAlgorithm()` → `private`
5. `listNFT()` → `public` or `external`

</details>

---

### 11. Gas Optimization (5 points)

**Why is `external` with `calldata` more gas-efficient than `public` with `memory` for large arrays?**

<details>
<summary>Answer</summary>

`calldata` is a non-modifiable, non-memory area where function arguments are stored. It doesn't require copying data to memory, saving gas. `public` functions with arrays create a copy in memory, which costs more gas.

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 65-75 | Excellent | Ready for Module 3! |
| 55-64 | Good | Review weak areas, then continue |
| 45-54 | Fair | Review README and exercises |
| <45 | Needs Work | Re-study Module 2 thoroughly |

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

**Scored 55+?** → [Continue to Module 3](../module-3/README.md)  
**Scored <55?** → Review [Module 2 README](README.md) and retry exercises
