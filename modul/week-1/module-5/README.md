# Module 5: Structs, Enums & Mappings

## 🎯 Learning Objectives

After completing this module, you will be able to:
- Create and use structs for complex data structures
- Implement enums for state management
- Use mappings for efficient key-value storage
- Work with dynamic and fixed-size arrays
- Combine structs, enums, and mappings effectively

## 📚 Prerequisites

- Module 1: Solidity Basics & Data Types ✅
- Module 2: Functions & Visibility ✅
- Module 3: Modifiers & Access Control ✅

## ⏱️ Estimated Time

40-50 minutes

---

## 📖 Core Concepts

### 1. Structs - Custom Data Types

**Structs** allow you to group multiple variables into a single custom type. Think of it like creating a "class" or "object" in other languages.

From the transcription:
> *"kalau struct itu lebih mirip biodata"*

### Basic Struct Syntax

```solidity
struct Person {
    string name;
    uint256 age;
    bool isStudent;
    address wallet;
}

// Using the struct
Person public person;
Person[] public people;  // Array of structs
mapping(address => Person) public users;  // Mapping with struct
```

### Creating Structs

```solidity
// Method 1: Named parameters (recommended)
person = Person({
    name: "Alice",
    age: 25,
    isStudent: true,
    wallet: msg.sender
});

// Method 2: Positional parameters
person = Person("Alice", 25, true, msg.sender);

// Method 3: Individual assignment
person.name = "Alice";
person.age = 25;
person.isStudent = true;
person.wallet = msg.sender;
```

---

### 2. Enums - Named Constants

**Enums** create a custom type with a fixed set of named values. They're perfect for state machines.

From the transcription:
> *"ENUM itu kurang lebih kita implementasi juga modifier disini"*
> *"enum itu kurang lebih kayak dia ngasih pilihan gitu"*

### Basic Enum Syntax

```solidity
enum Status {
    Pending,    // 0
    Completed,  // 1
    Failed      // 2
}

Status public status;
```

### Using Enums

```solidity
// Set status
status = Status.Pending;
status = Status.Completed;

// Compare status
if (status == Status.Pending) {
    // Do something
}

// Get numeric value (for debugging)
uint256 statusValue = uint256(status);  // 0, 1, or 2
```

### Real-World Example: Order Status

```solidity
enum OrderStatus {
    Created,      // 0
    Paid,         // 1
    Shipped,      // 2
    Delivered,    // 3
    Cancelled     // 4
}

struct Order {
    uint256 id;
    address buyer;
    uint256 amount;
    OrderStatus status;
}
```

---

### 3. Mappings - Key-Value Storage

**Mappings** are hash tables that store key-value pairs. They're like JavaScript objects or Python dictionaries.

From the transcription:
> *"mapping mapping ini apa ya kayak JSON mungkin"*

### Basic Mapping Syntax

```solidity
// mapping(keyType => valueType)
mapping(address => uint256) public balances;
mapping(uint256 => User) public users;
mapping(address => mapping(address => uint256)) public allowances;
```

### Key Points About Mappings

1. **Default values**: Unset keys return default values (0, false, empty)
2. **No iteration**: You cannot loop through mappings
3. **Gas efficient**: Cheaper than arrays for lookups
4. **No length**: Cannot get the "size" of a mapping

```solidity
mapping(address => uint256) public balances;

// Set value
balances[msg.sender] = 100;

// Get value
uint256 balance = balances[msg.sender];

// ❌ These DON'T work:
// uint256 length = balances.length;  // Error!
// for (address addr in balances) {}   // Error!
```

---

### 4. Arrays - Ordered Lists

#### **Dynamic Arrays**

```solidity
uint256[] public numbers;  // Can grow/shrink

// Add elements
numbers.push(1);
numbers.push(2);
numbers.push(3);

// Get length
uint256 len = numbers.length;  // 3

// Access elements
uint256 first = numbers[0];  // 1

// Remove last element
numbers.pop();  // Removes 3

// Remove specific element (manual)
function remove(uint256 index) public {
    require(index < numbers.length, "Index out of bounds");
    numbers[index] = numbers[numbers.length - 1];
    numbers.pop();
}
```

#### **Fixed-Size Arrays**

```solidity
uint256[5] public fixedArray;  // Exactly 5 elements

fixedArray[0] = 1;
fixedArray[4] = 5;

// ❌ fixedArray.push(6);  // Error! Fixed size
```

---

### 5. Combining Structs, Enums & Mappings

This is where the magic happens! Let's combine all three:

```solidity
enum UserRole {
    Viewer,     // 0
    Editor,     // 1
    Admin       // 2
}

struct User {
    uint256 id;
    string name;
    UserRole role;
    bool isActive;
}

contract TeamManager {
    mapping(address => User) public users;
    address[] public allUsers;
    uint256 public nextId = 1;
    
    function addUser(string calldata name) public {
        require(!users[msg.sender].isActive, "User exists");
        
        users[msg.sender] = User({
            id: nextId++,
            name: name,
            role: UserRole.Viewer,
            isActive: true
        });
        
        allUsers.push(msg.sender);
    }
    
    function updateUserRole(address user, UserRole newRole) public {
        require(users[msg.sender].role == UserRole.Admin, "Not admin");
        users[user].role = newRole;
    }
}
```

---

## 🔍 Code Walkthrough

Let's analyze `Week1_3.sol`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Week1_3 {
    error UserExist();
    
    // Struct: Custom data type for User
    struct User {
        uint256 id;
        string name;
        bool isStudent;
    }
    
    // Dynamic array of User structs
    User[] public users;
    
    // Mapping: address => User
    // Each address maps to a User struct
    mapping(address => User) public user;
    
    // Modifier to check if user already exists
    modifier userExist() {
        _userExist();
        _;
    }
    
    /// @notice Add a new user
    /// @param name User's name
    /// @param isStudent Whether user is a student
    function addUser(string calldata name, bool isStudent) public userExist {
        // Add to array (dynamic, keeps growing)
        users.push(User({
            id: users.length + 1, 
            name: name, 
            isStudent: isStudent
        }));
        
        // Add to mapping (overwrites if exists)
        user[msg.sender] = User({
            id: users.length, 
            name: name, 
            isStudent: isStudent
        });
    }
    
    /// @notice Edit existing user
    /// @param name New name
    /// @param isStudent New student status
    function editUser(string calldata name, bool isStudent) public {
        // Update user, preserve the ID
        user[msg.sender] = User({
            id: user[msg.sender].id, 
            name: name, 
            isStudent: isStudent
        });
    }
    
    /// @notice Check if user exists (ID != 0 means exists)
    function _userExist() internal view {
        if (user[msg.sender].id != 0) revert UserExist();
    }
    
    /// @notice Get total number of users
    /// @return Length of users array
    function getLengthUsers() public view returns (uint256) {
        return users.length;
    }
}
```

### Key Patterns:

1. **Struct for data grouping**: `User` combines id, name, isStudent
2. **Array for iteration**: `users[]` allows getting all users
3. **Mapping for quick lookup**: `user[address]` for O(1) access
4. **ID check for existence**: `id != 0` means user exists
5. **Custom error**: `UserExist()` for gas efficiency

---

## 🛠️ Hands-On Exercises

### Exercise 5.1: Basic Struct & Mapping

**Task**: Create a `StudentRegistry` contract with structs and mappings.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract StudentRegistry {
    error StudentExists();
    error StudentNotFound();
    
    struct Student {
        uint256 id;
        string name;
        uint256 grade;
        bool isActive;
    }
    
    mapping(uint256 => Student) public students;
    uint256 private nextId = 1;
    
    function enroll(string calldata name, uint256 grade) public {
        uint256 id = nextId;
        students[id] = Student({
            id: id,
            name: name,
            grade: grade,
            isActive: true
        });
        nextId++;
    }
    
    function getStudent(uint256 id) public view returns (Student memory) {
        require(students[id].id != 0, "Student not found");
        return students[id];
    }
}
```

---

### Exercise 5.2: Enum State Machine

**Task**: Implement an order management system with enum states.

**Solution**:
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract OrderManagement {
    enum OrderStatus {
        Created,
        Paid,
        Shipped,
        Delivered,
        Cancelled
    }
    
    struct Order {
        uint256 id;
        address buyer;
        uint256 amount;
        OrderStatus status;
    }
    
    mapping(uint256 => Order) public orders;
    uint256 private nextOrderId = 1;
    
    function createOrder(uint256 amount) public returns (uint256) {
        uint256 orderId = nextOrderId++;
        orders[orderId] = Order({
            id: orderId,
            buyer: msg.sender,
            amount: amount,
            status: OrderStatus.Created
        });
        return orderId;
    }
    
    function payOrder(uint256 orderId) public {
        require(orders[orderId].buyer == msg.sender, "Not buyer");
        require(orders[orderId].status == OrderStatus.Created, "Invalid state");
        orders[orderId].status = OrderStatus.Paid;
    }
    
    function shipOrder(uint256 orderId) public {
        require(orders[orderId].status == OrderStatus.Paid, "Not paid");
        orders[orderId].status = OrderStatus.Shipped;
    }
}
```

---

## ⚠️ Common Pitfalls

### 1. Mapping Doesn't Track Keys

```solidity
mapping(address => uint256) public balances;

// ❌ Can't get all addresses
// for (address addr in balances) {}  // Error!

// ✅ Solution: Track keys separately
address[] public allUsers;
mapping(address => bool) public isUser;

function addUser(address user) public {
    if (!isUser[user]) {
        allUsers.push(user);
        isUser[user] = true;
    }
}
```

### 2. Struct Memory vs Storage

```solidity
// ❌ Wrong: Can't modify struct in mapping directly
function updateName(uint256 id, string memory newName) public {
    students[id].name = newName;  // This works!
}

// ✅ Correct: Direct assignment works
// But for complex updates, use local variable
function updateStudent(uint256 id, string memory newName) public {
    Student storage student = students[id];  // storage reference
    student.name = newName;
}
```

### 3. Enum Comparison

```solidity
// ❌ Don't compare with numbers
if (status == 0) {}  // Works but unclear

// ✅ Compare with enum values
if (status == Status.Pending) {}  // Clear and safe
```

---

## 📝 Self-Check Quiz

1. **What's the default value of an unset mapping key?**
   <details><summary>Answer</summary>The default value of the value type (0 for uint, false for bool, empty for structs)</details>

2. **Can you iterate over a mapping?**
   <details><summary>Answer</summary>No, mappings don't support iteration</details>

3. **How do you check if a struct in a mapping exists?**
   <details><summary>Answer</summary>Check if a unique field (like id) is non-zero</details>

4. **What's the difference between `User[]` and `mapping(address => User)`?**
   <details><summary>Answer</summary>Array is ordered and iterable, mapping is key-value with O(1) lookup</details>

5. **Can you change an enum value after setting it?**
   <details><summary>Answer</summary>Yes, enums are mutable</details>

---

## 📚 Additional Resources

- **Solidity Docs**: [Structs](https://docs.soliditylang.org/en/latest/types.html#structs)
- **Solidity Docs**: [Mappings](https://docs.soliditylang.org/en/latest/types.html#mapping-types)
- **Solidity Docs**: [Enums](https://docs.soliditylang.org/en/latest/types.html#enums)
- **CryptoZombies**: Lesson 5 (Structs & Mappings)

---

## 🎯 What's Next?

Now that you understand data structures, move to **Module 6** where you'll learn about:
- Events and logging
- Foundry testing fundamentals
- vm.prank, vm.expectRevert, and fuzzing
- Writing comprehensive test suites

**Ready?** → [Go to Module 6](../module-6/README.md)
