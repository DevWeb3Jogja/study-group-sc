# Module 6: Quiz

Test your understanding of Events & Testing Fundamentals.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers (60/75 points)
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (5 points)

**What is the maximum number of `indexed` parameters an event can have?**

A) 1  
B) 2  
C) 3  
D) 4  

<details><summary>Answer</summary>C) 3</details>

---

### 2. Multiple Choice (5 points)

**Can smart contracts read events from other contracts?**

A) Yes, always  
B) Yes, but only indexed parameters  
C) No, events are for off-chain consumption only  
D) Only view functions can read events  

<details><summary>Answer</summary>C) No, events are for off-chain consumption only</details>

---

### 3. True/False (5 points)

**`vm.prank()` affects all subsequent calls until `vm.stopPrank()` is called.**

<details><summary>Answer</summary>False - `vm.prank()` only affects the next call. Use `vm.startPrank()` for multiple calls.</details>

---

### 4. True/False (5 points)

**Fuzz testing runs your test with random inputs to find edge cases.**

<details><summary>Answer</summary>True</details>

---

### 5. Multiple Choice (5 points)

**What does `makeAddr("alice")` do?**

A) Creates a new contract named alice  
B) Returns a deterministic address based on the string "alice"  
C) Creates a random address each time  
D) Deploys a test contract  

<details><summary>Answer</summary>B) Returns a deterministic address based on the string "alice"</details>

---

### 6. Multiple Choice (5 points)

**How do you test that a function reverts with a custom error?**

A) `vm.expectRevert("Error message")`  
B) `vm.expectRevert(MyContract.MyError.selector)`  
C) `assertRevert(contract.function())`  
D) `requireRevert(contract.function())`  

<details><summary>Answer</summary>B) `vm.expectRevert(MyContract.MyError.selector)`</details>

---

### 7. Short Answer (10 points)

**What's the difference between `vm.prank()` and `vm.startPrank()`?**

<details>
<summary>Answer</summary>

- `vm.prank(address)`: Makes only the **next call** appear to come from the specified address
- `vm.startPrank(address)`: Makes **all subsequent calls** appear to come from the specified address until `vm.stopPrank()` is called

Example:
```solidity
vm.prank(alice);
contract.function1();  // Called as alice

vm.startPrank(bob);
contract.function2();  // Called as bob
contract.function3();  // Called as bob
vm.stopPrank();
contract.function4();  // Called as msg.sender (not bob)
```

</details>

---

### 8. Code Analysis (10 points)

**What's wrong with this event definition?**

```solidity
event UserRegistered(address user, uint256 id, string name, uint256 timestamp);
```

**How would you improve it for better off-chain filtering?**

<details>
<summary>Answer</summary>

The event has no `indexed` parameters, making it hard to filter events by specific users or IDs.

Improved version:
```solidity
event UserRegistered(
    address indexed user,      // Filter by user address
    uint256 indexed id,        // Filter by user ID
    string name,               // Data only
    uint256 timestamp          // Data only
);
```

This allows filtering by user address and ID efficiently.

</details>

---

### 9. Practical (15 points)

**Write a test that:**
1. Uses `vm.prank()` to call a function as different users
2. Uses `vm.expectRevert()` to test an error case
3. Uses `makeAddr()` for test addresses

<details>
<summary>Answer</summary>

```solidity
function testAccessControl() public {
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    
    // Alice can call owner function
    vm.prank(owner);
    contract.ownerFunction();
    
    // Bob cannot call owner function
    vm.prank(bob);
    vm.expectRevert(MyContract.NotOwner.selector);
    contract.ownerFunction();
}
```

</details>

---

### 10. Fuzz Testing (10 points)

**Convert this regular test to a fuzz test:**

```solidity
function testSetNumber() public {
    contract.setNumber(42);
    assertEq(contract.getNumber(), 42);
}
```

<details>
<summary>Answer</summary>

```solidity
function testFuzzSetNumber(uint256 x) public {
    contract.setNumber(x);
    assertEq(contract.getNumber(), x);
}
```

Foundry will run this test 256 times with different random values of `x`.

To add constraints:
```solidity
function testFuzzSetNumber(uint256 x) public {
    vm.assume(x < 1000000);  // Only test with x < 1 million
    contract.setNumber(x);
    assertEq(contract.getNumber(), x);
}
```

</details>

---

### 11. Test Organization (10 points)

**Why use `setUp()` instead of creating contracts in each test?**

<details>
<summary>Answer</summary>

**Benefits of `setUp()`:**

1. **DRY (Don't Repeat Yourself)**: No code duplication
2. **Consistency**: All tests start with the same state
3. **Maintainability**: Change setup in one place
4. **Readability**: Tests focus on what they're testing, not setup
5. **Performance**: Can be more efficient for complex setups

**Example:**
```solidity
// ❌ Without setUp
function test1() public {
    Contract c = new Contract();
    c.initialize();
    // test logic
}

function test2() public {
    Contract c = new Contract();
    c.initialize();
    // test logic
}

// ✅ With setUp
function setUp() public {
    c = new Contract();
    c.initialize();
}

function test1() public {
    // test logic (c is ready)
}

function test2() public {
    // test logic (c is ready)
}
```

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 65-75 | Excellent | Week 1 Complete! |
| 55-64 | Good | Review weak areas, then continue |
| 45-54 | Fair | Review README and exercises |
| <45 | Needs Work | Re-study Module 6 thoroughly |

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

**Scored 55+?** → [Go to Week 1 Overview](../README.md)  
**Scored <55?** → Review [Module 6 README](README.md) and retry exercises
