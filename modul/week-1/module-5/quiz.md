# Module 5: Quiz

Test your understanding of Structs, Enums & Mappings.

---

## Instructions

- Answer all questions without looking at the solutions
- Aim for at least 80% correct answers (60/75 points)
- Review the README if you get stuck

---

## Questions

### 1. Multiple Choice (5 points)

**What is the default value returned by a mapping for an unset key?**

A) `null`  
B) The default value of the value type  
C) `undefined`  
D) It reverts  

<details><summary>Answer</summary>B) The default value of the value type</details>

---

### 2. Multiple Choice (5 points)

**Can you iterate over all keys in a mapping?**

A) Yes, with a for loop  
B) Yes, with foreach  
C) No, mappings don't support iteration  
D) Only in view functions  

<details><summary>Answer</summary>C) No, mappings don't support iteration</details>

---

### 3. True/False (5 points)

**A struct can contain other structs as members.**

<details><summary>Answer</summary>True</details>

---

### 4. True/False (5 points)

**Enum values start from 1 by default.**

<details><summary>Answer</summary>False - they start from 0</details>

---

### 5. Multiple Choice (5 points)

**Which is more gas-efficient for looking up a user's balance by address?**

A) `User[]` array (search through all)  
B) `mapping(address => uint256)`  
C) Both are the same  
D) Depends on the number of users  

<details><summary>Answer</summary>B) `mapping(address => uint256)` - O(1) lookup</details>

---

### 6. Multiple Choice (5 points)

**How do you check if a struct exists in a mapping?**

A) `if (mapping[key] != null)`  
B) `if (mapping.exists(key))`  
C) Check if a unique field (like id) is non-zero  
D) You can't check existence  

<details><summary>Answer</summary>C) Check if a unique field (like id) is non-zero</details>

---

### 7. Code Analysis (10 points)

**What's wrong with this code?**

```solidity
struct User {
    uint256 id;
    string name;
}

mapping(address => User) public users;

function getUserCount() public view returns (uint256) {
    return users.length;  // Problem here
}
```

<details>
<summary>Answer</summary>

Mappings don't have a `.length` property. You cannot get the "size" of a mapping.

Solution: Track the count separately:
```solidity
uint256 public userCount = 0;

function addUser(string calldata name) public {
    users[msg.sender] = User({id: userCount++, name: name});
}
```

</details>

---

### 8. Practical (15 points)

**Write a contract with:**
- A struct `Product` with id, name, price, and inStock (bool)
- A mapping to store products by ID
- A function to add products
- A function to get product by ID

<details>
<summary>Answer</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract ProductStore {
    error ProductNotFound();
    
    struct Product {
        uint256 id;
        string name;
        uint256 price;
        bool inStock;
    }
    
    mapping(uint256 => Product) public products;
    uint256 private nextId = 1;
    
    function addProduct(string calldata name, uint256 price, bool inStock) public {
        uint256 id = nextId++;
        products[id] = Product({
            id: id,
            name: name,
            price: price,
            inStock: inStock
        });
    }
    
    function getProduct(uint256 id) public view returns (Product memory) {
        if (products[id].id == 0) revert ProductNotFound();
        return products[id];
    }
}
```

</details>

---

### 9. Enum State Machine (10 points)

**Create an enum for a payment status with states:**
- Pending
- Processing
- Completed
- Failed

**Write a function that transitions from Pending to Processing.**

<details>
<summary>Answer</summary>

```solidity
enum PaymentStatus {
    Pending,
    Processing,
    Completed,
    Failed
}

mapping(uint256 => PaymentStatus) public payments;

function startProcessing(uint256 paymentId) public {
    require(payments[paymentId] == PaymentStatus.Pending, "Not pending");
    payments[paymentId] = PaymentStatus.Processing;
}
```

</details>

---

### 10. Array Operations (10 points)

**Given this array:**
```solidity
uint256[] public numbers = [1, 2, 3, 4, 5];
```

**Write a function to remove the element at index 2 (value 3) efficiently.**

<details>
<summary>Answer</summary>

```solidity
function removeAtIndex(uint256 index) public {
    require(index < numbers.length, "Index out of bounds");
    
    // Swap with last element and pop (efficient, but doesn't preserve order)
    numbers[index] = numbers[numbers.length - 1];
    numbers.pop();
}
```

Note: This doesn't preserve order. If order matters, you'd need to shift all elements.

</details>

---

### 11. Best Practices (10 points)

**Why use both an array AND a mapping for storing users?**

```solidity
User[] public allUsers;           // Array
mapping(address => User) public users;  // Mapping
```

<details>
<summary>Answer</summary>

**Array benefits:**
- Can iterate over all users
- Can get total count with `.length`
- Ordered storage

**Mapping benefits:**
- O(1) lookup by address
- Gas efficient for individual lookups

**Combined:** Best of both worlds - iterate with array, quick lookup with mapping.

</details>

---

## Scoring

| Score | Grade | Recommendation |
|-------|-------|----------------|
| 65-75 | Excellent | Ready for Module 6! |
| 55-64 | Good | Review weak areas, then continue |
| 45-54 | Fair | Review README and exercises |
| <45 | Needs Work | Re-study Module 5 thoroughly |

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

**Scored 55+?** → [Continue to Module 6](../module-6/README.md)  
**Scored <55?** → Review [Module 5 README](README.md) and retry exercises
