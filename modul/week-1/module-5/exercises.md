# Module 5: Exercises

## Practice Tasks for Structs, Enums & Mappings

---

## Exercise 5.1: Student Registry ⭐

**Difficulty**: Easy  
**Time**: 15 minutes

### Task

Create a `StudentRegistry.sol` contract that:
- Uses a struct to store student information (id, name, grade, isActive)
- Uses a mapping to store students by ID
- Allows enrollment and retrieval of students

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract StudentRegistry {
    error StudentNotFound();
    
    struct Student {
        uint256 id;
        string name;
        uint256 grade;
        bool isActive;
    }
    
    mapping(uint256 => Student) public students;
    uint256 private nextId = 1;
    
    event StudentEnrolled(uint256 indexed id, string name, uint256 grade);
    
    function enroll(string calldata name, uint256 grade) public {
        uint256 id = nextId++;
        students[id] = Student({
            id: id,
            name: name,
            grade: grade,
            isActive: true
        });
        
        emit StudentEnrolled(id, name, grade);
    }
    
    function getStudent(uint256 id) public view returns (Student memory) {
        if (students[id].id == 0) revert StudentNotFound();
        return students[id];
    }
    
    function updateGrade(uint256 id, uint256 newGrade) public {
        if (students[id].id == 0) revert StudentNotFound();
        students[id].grade = newGrade;
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {StudentRegistry} from "@src/week1/StudentRegistry.sol";

contract StudentRegistryTest is Test {
    StudentRegistry public registry;
    
    function setUp() public {
        registry = new StudentRegistry();
    }
    
    function testEnroll() public {
        registry.enroll("Alice", 95);
        
        (uint256 id, string memory name, uint256 grade, bool isActive) = 
            registry.getStudent(1);
        
        assertEq(id, 1);
        assertEq(name, "Alice");
        assertEq(grade, 95);
        assertTrue(isActive);
    }
    
    function testUpdateGrade() public {
        registry.enroll("Bob", 80);
        registry.updateGrade(1, 90);
        
        (,,, uint256 grade,) = registry.getStudent(1);
        assertEq(grade, 90);
    }
}
```

</details>

---

## Exercise 5.2: Order Management System ⭐⭐

**Difficulty**: Medium  
**Time**: 25 minutes

### Task

Create an `OrderManagement.sol` contract with:
- An enum for order status (Created, Paid, Shipped, Delivered, Cancelled)
- A struct for Order with all relevant fields
- Functions to transition between states

### Requirements

- Only buyer can pay for their order
- Only paid orders can be shipped
- Implement proper state transitions

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract OrderManagement {
    error InvalidStateTransition();
    error NotBuyer();
    error OrderNotFound();
    
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
        uint256 createdAt;
    }
    
    mapping(uint256 => Order) public orders;
    uint256 private nextOrderId = 1;
    
    event OrderCreated(uint256 indexed orderId, address buyer, uint256 amount);
    event OrderPaid(uint256 indexed orderId);
    event OrderShipped(uint256 indexed orderId);
    event OrderDelivered(uint256 indexed orderId);
    event OrderCancelled(uint256 indexed orderId);
    
    function createOrder(uint256 amount) public returns (uint256) {
        uint256 orderId = nextOrderId++;
        orders[orderId] = Order({
            id: orderId,
            buyer: msg.sender,
            amount: amount,
            status: OrderStatus.Created,
            createdAt: block.timestamp
        });
        
        emit OrderCreated(orderId, msg.sender, amount);
        return orderId;
    }
    
    function payOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        
        if (order.id == 0) revert OrderNotFound();
        if (order.buyer != msg.sender) revert NotBuyer();
        if (order.status != OrderStatus.Created) revert InvalidStateTransition();
        
        order.status = OrderStatus.Paid;
        emit OrderPaid(orderId);
    }
    
    function shipOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        
        if (order.id == 0) revert OrderNotFound();
        if (order.status != OrderStatus.Paid) revert InvalidStateTransition();
        
        order.status = OrderStatus.Shipped;
        emit OrderShipped(orderId);
    }
    
    function deliverOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        
        if (order.id == 0) revert OrderNotFound();
        if (order.status != OrderStatus.Shipped) revert InvalidStateTransition();
        
        order.status = OrderStatus.Delivered;
        emit OrderDelivered(orderId);
    }
    
    function cancelOrder(uint256 orderId) public {
        Order storage order = orders[orderId];
        
        if (order.id == 0) revert OrderNotFound();
        if (order.buyer != msg.sender) revert NotBuyer();
        if (order.status != OrderStatus.Created && order.status != OrderStatus.Paid) {
            revert InvalidStateTransition();
        }
        
        order.status = OrderStatus.Cancelled;
        emit OrderCancelled(orderId);
    }
    
    function getOrder(uint256 orderId) public view returns (Order memory) {
        if (orders[orderId].id == 0) revert OrderNotFound();
        return orders[orderId];
    }
}
```

</details>

---

## Exercise 5.3: NFT Collection ⭐⭐

**Difficulty**: Medium  
**Time**: 30 minutes

### Task

Create a simple `NFTCollection.sol` contract that:
- Uses a struct for NFT metadata
- Uses mappings to track ownership
- Uses arrays to track all NFTs

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract NFTCollection {
    error NFTNotFound();
    error NotOwner();
    
    struct NFT {
        uint256 id;
        string name;
        string uri;
        address owner;
        bool exists;
    }
    
    mapping(uint256 => NFT) public nfts;
    mapping(address => uint256[]) public ownedNFTs;
    uint256[] public allNFTIds;
    uint256 private nextId = 1;
    
    event NFTMinted(uint256 indexed id, address indexed owner, string name);
    event NFTTransferred(uint256 indexed id, address from, address to);
    
    function mint(address to, string calldata name, string calldata uri) public {
        uint256 id = nextId++;
        
        nfts[id] = NFT({
            id: id,
            name: name,
            uri: uri,
            owner: to,
            exists: true
        });
        
        ownedNFTs[to].push(id);
        allNFTIds.push(id);
        
        emit NFTMinted(id, to, name);
    }
    
    function transfer(address to, uint256 tokenId) public {
        NFT storage nft = nfts[tokenId];
        
        if (!nft.exists) revert NFTNotFound();
        if (nft.owner != msg.sender) revert NotOwner();
        
        // Remove from sender's list
        _removeFromOwned(nft.owner, tokenId);
        
        // Update ownership
        nft.owner = to;
        
        // Add to recipient's list
        ownedNFTs[to].push(tokenId);
        
        emit NFTTransferred(tokenId, msg.sender, to);
    }
    
    function _removeFromOwned(address owner, uint256 tokenId) internal {
        uint256[] storage owned = ownedNFTs[owner];
        for (uint256 i = 0; i < owned.length; i++) {
            if (owned[i] == tokenId) {
                owned[i] = owned[owned.length - 1];
                owned.pop();
                break;
            }
        }
    }
    
    function getOwnedNFTs(address owner) public view returns (uint256[] memory) {
        return ownedNFTs[owner];
    }
    
    function getNFT(uint256 tokenId) public view returns (NFT memory) {
        if (!nfts[tokenId].exists) revert NFTNotFound();
        return nfts[tokenId];
    }
}
```

</details>

---

## Exercise 5.4: Library Management System ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 40 minutes

### Task

Create a `LibraryManager.sol` contract with:
- Books (struct with id, title, author, isAvailable)
- Members (struct with id, name, borrowedBooks)
- Enums for book status
- Mappings for quick lookups
- Arrays for iteration

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract LibraryManager {
    error BookNotFound();
    error MemberNotFound();
    error BookNotAvailable();
    error NotMember();
    
    enum BookStatus {
        Available,
        Borrowed,
        Reserved,
        Lost
    }
    
    struct Book {
        uint256 id;
        string title;
        string author;
        BookStatus status;
        address borrowedBy;
    }
    
    struct Member {
        uint256 id;
        string name;
        uint256[] borrowedBooks;
        bool isActive;
    }
    
    mapping(uint256 => Book) public books;
    mapping(uint256 => Member) public members;
    mapping(address => uint256) public memberAddress;
    
    uint256[] public allBookIds;
    uint256[] public allMemberIds;
    
    uint256 private nextBookId = 1;
    uint256 private nextMemberId = 1;
    
    event MemberRegistered(uint256 indexed id, address indexed addr, string name);
    event BookAdded(uint256 indexed id, string title, string author);
    event BookBorrowed(uint256 indexed bookId, address indexed member);
    event BookReturned(uint256 indexed bookId);
    
    function registerMember(string calldata name) public {
        require(memberAddress[msg.sender] == 0, "Already registered");
        
        uint256 id = nextMemberId++;
        members[id] = Member({
            id: id,
            name: name,
            borrowedBooks: new uint256[](0),
            isActive: true
        });
        
        memberAddress[msg.sender] = id;
        allMemberIds.push(id);
        
        emit MemberRegistered(id, msg.sender, name);
    }
    
    function addBook(string calldata title, string calldata author) public {
        uint256 id = nextBookId++;
        books[id] = Book({
            id: id,
            title: title,
            author: author,
            status: BookStatus.Available,
            borrowedBy: address(0)
        });
        
        allBookIds.push(id);
        emit BookAdded(id, title, author);
    }
    
    function borrowBook(uint256 bookId) public {
        uint256 memberId = memberAddress[msg.sender];
        if (memberId == 0) revert NotMember();
        
        Book storage book = books[bookId];
        if (book.id == 0) revert BookNotFound();
        if (book.status != BookStatus.Available) revert BookNotAvailable();
        
        book.status = BookStatus.Borrowed;
        book.borrowedBy = msg.sender;
        
        Member storage member = members[memberId];
        member.borrowedBooks.push(bookId);
        
        emit BookBorrowed(bookId, msg.sender);
    }
    
    function returnBook(uint256 bookId) public {
        Book storage book = books[bookId];
        
        if (book.id == 0) revert BookNotFound();
        if (book.borrowedBy != msg.sender) revert NotMember();
        
        book.status = BookStatus.Available;
        book.borrowedBy = address(0);
        
        // Remove from member's borrowed list
        uint256 memberId = memberAddress[msg.sender];
        Member storage member = members[memberId];
        
        for (uint256 i = 0; i < member.borrowedBooks.length; i++) {
            if (member.borrowedBooks[i] == bookId) {
                member.borrowedBooks[i] = member.borrowedBooks[member.borrowedBooks.length - 1];
                member.borrowedBooks.pop();
                break;
            }
        }
        
        emit BookReturned(bookId);
    }
    
    function getMemberBorrowedBooks(address memberAddr) 
        public 
        view 
        returns (uint256[] memory) 
    {
        uint256 memberId = memberAddress[memberAddr];
        return members[memberId].borrowedBooks;
    }
}
```

</details>

---

## ✅ Completion Checklist

Before moving to Module 6, ensure you can:

- [ ] Create and use structs for complex data
- [ ] Implement enums for state management
- [ ] Use mappings for efficient key-value storage
- [ ] Work with dynamic arrays (push, pop, remove)
- [ ] Combine structs, enums, and mappings effectively
- [ ] Complete at least 2 exercises above

---

## 🎯 Challenge: Decentralized Marketplace ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 60 minutes

### Task

Build a `Marketplace.sol` contract with:

**Requirements:**
1. Listings (struct with item details, price, seller, status)
2. Status enum (Active, Sold, Cancelled)
3. Mappings for listings and offers
4. Offer system with structs
5. Complete buy/sell flow

**Features:**
- Sellers can create listings
- Buyers can make offers
- Sellers can accept/reject offers
- Escrow system for safe transactions

---

**Ready for the next module?** → [Go to Module 6](../module-6/README.md)
