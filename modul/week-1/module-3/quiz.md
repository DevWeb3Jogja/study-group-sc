# Module 3: Quiz

Test your understanding of Modifiers & Access Control.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers (60/75 points)
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (5 points)

**What does the `_` (underscore) represent in a modifier?**

A) A comment placeholder  
B) Where the function body will be inserted  
C) A special variable for msg.sender  
D) The return value  

<details><summary>Answer</summary>B) Where the function body will be inserted</details>

---

### 2. Multiple Choice (5 points)

**When does a constructor execute?**

A) Every time a function is called  
B) When the contract is compiled  
C) Once when the contract is deployed  
D) When the owner calls it  

<details><summary>Answer</summary>C) Once when the contract is deployed</details>

---

### 3. True/False (5 points)

**Custom errors with `revert` are more gas-efficient than `require` with strings.**

<details><summary>Answer</summary>True</details>

---

### 4. True/False (5 points)

**A function can only have one modifier.**

<details><summary>Answer</summary>False - functions can have multiple modifiers, they execute in order</details>

---

### 5. Multiple Choice (5 points)

**What is the purpose of the `whenPaused` modifier?**

A) To allow only the owner to call functions  
B) To restrict function access during emergencies  
C) To pause the blockchain  
D) To stop gas fees  

<details><summary>Answer</summary>B) To restrict function access during emergencies</details>

---

### 6. Multiple Choice (5 points)

**In what order do multiple modifiers execute?**

A) Random order  
B) Right to left  
C) Left to right (in order written)  
D) Simultaneously  

<details><summary>Answer</summary>C) Left to right (in order written)</details>

---

### 7. Code Analysis (10 points)

**What's wrong with this modifier?**

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    // Missing something?
}
```

<details>
<summary>Answer</summary>

The modifier is missing the `_` placeholder. Without it, the function body will never execute!

Correct version:
```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

</details>

---

### 8. Practical (15 points)

**Write a contract with:**
- A custom error `NotAllowed()`
- A modifier `onlyAuthorized()` that uses the custom error
- An internal function `_checkAuthorization()` for the logic
- A function `accessResource()` that uses the modifier

<details>
<summary>Answer</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract AccessControl {
    error NotAllowed();
    
    mapping(address => bool) public authorizedUsers;
    
    modifier onlyAuthorized() {
        _checkAuthorization();
        _;
    }
    
    function accessResource() public onlyAuthorized {
        // Resource access logic
    }
    
    function _checkAuthorization() internal view {
        if (!authorizedUsers[msg.sender]) revert NotAllowed();
    }
}
```

</details>

---

### 9. Scenario-Based (10 points)

**You're building a DeFi protocol. Match the situation to the appropriate modifier:**

1. During a hack, you need to stop all trading immediately
2. Only the protocol owner should be able to change fees
3. A function should only work after a governance vote passes
4. Users shouldn't be able to withdraw more than once per day

<details>
<summary>Answer</summary>

1. `whenPaused()` or emergency pause modifier
2. `onlyOwner()`
3. `afterGovernanceVote()` or time-lock modifier
4. `rateLimit()` or cooldown modifier

</details>

---

### 10. Gas Optimization (5 points)

**Why are custom errors more gas-efficient than `require` with strings?**

<details>
<summary>Answer</summary>

Custom errors don't store error message strings in the contract bytecode. They use a selector (4 bytes) instead of storing the full string, which significantly reduces deployment and execution costs.

</details>

---

### 11. Code Reading (10 points)

**Analyze this code and answer the questions:**

```solidity
contract Example {
    address public owner;
    bool public paused = false;
    
    modifier A() {
        require(!paused, "Paused");
        _;
    }
    
    modifier B() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function action() public A B {
        // Do something
    }
}
```

1. In what order do the checks happen?
2. What happens if the contract is paused and owner calls `action()`?

<details>
<summary>Answer</summary>

1. Modifier A checks first (not paused), then modifier B checks (is owner)
2. The transaction reverts with "Paused" - modifier A's check fails first

</details>

---

### 12. Best Practices (10 points)

**Why is it better to split modifier logic into internal functions?**

```solidity
// Pattern A
modifier onlyOwner() {
    if (msg.sender != owner) revert NotOwner();
    _;
}

// Pattern B
modifier onlyOwner() {
    _onlyOwner();
    _;
}

function _onlyOwner() internal view {
    if (msg.sender != owner) revert NotOwner();
}
```

Which pattern is better and why?

<details>
<summary>Answer</summary>

**Pattern B is better** because:

1. **Testability**: `_onlyOwner()` can be tested independently
2. **Reusability**: Internal function can be called from other places
3. **Override capability**: Child contracts can override `_onlyOwner()`
4. **Cleaner modifiers**: Modifiers stay simple and readable
5. **Debugging**: Easier to debug and trace issues

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 65-75 | Excellent | Ready for Module 4! |
| 55-64 | Good | Review weak areas, then continue |
| 45-54 | Fair | Review README and exercises |
| <45 | Needs Work | Re-study Module 3 thoroughly |

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

**Scored 55+?** → [Continue to Module 4](../module-4/README.md)  
**Scored <55?** → Review [Module 3 README](README.md) and retry exercises
