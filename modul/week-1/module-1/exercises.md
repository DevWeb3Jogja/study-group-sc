# Module 1: Exercises

## Practice Tasks

Complete these exercises to reinforce your understanding of Solidity data types.

---

## Exercise 1.1: Basic Variable Declaration ⭐

**Difficulty**: Easy  
**Time**: 10 minutes

### Task

Create a new contract called `Profile.sol` in `src/week1/` with the following state variables:

1. `age` (uint256) - your age or any positive number
2. `balance` (int256) - can be negative for representing debt
3. `walletAddress` (address) - any valid Ethereum address
4. `username` (bytes32) - your username as fixed bytes
5. `isActive` (bool) - whether the profile is active

### Starter Code

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Profile {
    // Your code here
}
```

### Solution

<details>
<summary>Click to reveal solution</summary>

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

</details>

### Test Your Contract

Create a test file `test/week1/Profile.t.sol`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Profile} from "@src/week1/Profile.sol";

contract ProfileTest is Test {
    Profile public profile;

    function setUp() public {
        profile = new Profile();
    }

    function testProfileVariables() public view {
        console.log("Age:", profile.age());
        console.log("Balance:", profile.balance());
        console.log("Wallet:", profile.walletAddress());
        console.log("Active:", profile.isActive());
    }
}
```

**Run the test**:
```bash
forge test --match-contract ProfileTest -vvv
```

---

## Exercise 1.2: Default Values Investigation ⭐

**Difficulty**: Easy  
**Time**: 10 minutes

### Task

Create a contract `Defaults.sol` that declares variables of each type **without** initializing them. Then create a test to verify their default values.

### Starter Code

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Defaults {
    // Declare variables without initialization
    uint256 public myUint;
    int256 public myInt;
    // Add more...
}
```

### Expected Default Values

| Type | Default Value |
|------|---------------|
| uint256 | 0 |
| int256 | 0 |
| address | 0x0000000000000000000000000000000000000000 |
| bytes32 | 0x0000000000000000000000000000000000000000000000000000000000000000 |
| bool | false |
| string | "" (empty string) |

### Solution

<details>
<summary>Click to reveal solution</summary>

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

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Defaults} from "@src/week1/Defaults.sol";

contract DefaultsTest is Test {
    Defaults public defaults;

    function setUp() public {
        defaults = new Defaults();
    }

    function testDefaultValues() public {
        assertEq(defaults.myUint(), 0);
        assertEq(defaults.myInt(), 0);
        assertEq(defaults.myAddress(), address(0));
        assertEq(defaults.myBool(), false);
        assertEq(defaults.myString(), "");
    }

    function testLogDefaultValues() public view {
        console.log("uint256 default:", defaults.myUint());
        console.log("int256 default:", defaults.myInt());
        console.log("address default:", defaults.myAddress());
        console.log("bool default:", defaults.myBool());
        console.log("string default:", defaults.myString());
    }
}
```

</details>

---

## Exercise 1.3: Mapping Practice ⭐⭐

**Difficulty**: Medium  
**Time**: 15 minutes

### Task

Create a `Voting.sol` contract with:

1. A mapping that tracks votes per address: `mapping(address => uint256)`
2. A function `vote(uint256 candidateId)` to cast a vote
3. A function `getVoteCount(address voter)` to get vote count for an address
4. A state variable to track total votes

### Requirements

- When a user votes, store the candidate ID in the mapping
- Track the total number of votes cast
- Make the mapping public so anyone can query it

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Voting {
    // Mapping to track votes per address
    mapping(address => uint256) public votes;
    
    // Total votes cast
    uint256 public totalVotes;
    
    /// @notice Cast a vote for a candidate
    /// @param candidateId The ID of the candidate to vote for
    function vote(uint256 candidateId) public {
        votes[msg.sender] = candidateId;
        totalVotes++;
    }
    
    /// @notice Get the vote count for a specific voter
    /// @param voter The address of the voter
    /// @return The candidate ID the voter voted for
    function getVoteCount(address voter) public view returns (uint256) {
        return votes[voter];
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Voting} from "@src/week1/Voting.sol";

contract VotingTest is Test {
    Voting public voting;
    
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    function setUp() public {
        voting = new Voting();
    }

    function testVote() public {
        vm.startPrank(alice);
        voting.vote(1);  // Vote for candidate 1
        vm.stopPrank();
        
        assertEq(voting.votes(alice), 1);
        assertEq(voting.totalVotes(), 1);
    }

    function testMultipleVotes() public {
        vm.startPrank(alice);
        voting.vote(1);
        vm.stopPrank();
        
        vm.startPrank(bob);
        voting.vote(2);
        vm.stopPrank();
        
        assertEq(voting.votes(alice), 1);
        assertEq(voting.votes(bob), 2);
        assertEq(voting.totalVotes(), 2);
    }

    function testGetVoteCount() public {
        vm.startPrank(alice);
        voting.vote(3);
        vm.stopPrank();
        
        assertEq(voting.getVoteCount(alice), 3);
        assertEq(voting.getVoteCount(bob), 0);  // Bob hasn't voted
    }
}
```

</details>

---

## Exercise 1.4: Understanding Underflow ⭐⭐

**Difficulty**: Medium  
**Time**: 10 minutes

### Task

1. Create a contract `UnderflowDemo.sol` with a `uint256` variable
2. Create a function `decrement()` that decreases the value
3. Write a test that demonstrates what happens when you try to decrement below 0

### Hint

In Solidity 0.8+, underflow causes a revert. You can test this with `vm.expectRevert()`.

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract UnderflowDemo {
    uint256 public number = 0;
    
    function decrement() public {
        number--;
    }
    
    function setNumber(uint256 _number) public {
        number = _number;
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {UnderflowDemo} from "@src/week1/UnderflowDemo.sol";

contract UnderflowDemoTest is Test {
    UnderflowDemo public demo;

    function setUp() public {
        demo = new UnderflowDemo();
    }

    function testDecrementFromZero() public {
        // This should revert because of underflow
        vm.expectRevert();
        demo.decrement();
    }

    function testDecrementFromPositive() public {
        demo.setNumber(5);
        demo.decrement();
        assertEq(demo.number(), 4);
    }
}
```

</details>

---

## Exercise 1.5: Gas Optimization Awareness ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 20 minutes

### Task

Research and write a short explanation (in your own words) about:

1. Why is storing data on-chain expensive?
2. What's the difference in gas cost between `bytes32` and `string` for fixed-length data?
3. When would you use a `mapping` instead of an array?

### Research Resources

- [Ethereum Gas Costs](https://ethereum.org/en/developers/docs/gas/)
- [Solidity Gas Optimization](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)

Write your answers in a file called `gas-notes.md` in the module-1 directory.

---

## 🎯 Challenge: Build a Simple Bank Contract ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 30 minutes

### Task

Combine everything you've learned to create a `SimpleBank.sol` contract:

**Requirements**:
1. Track balance per user (mapping)
2. Owner address (who deployed the contract)
3. Function to deposit (increase balance)
4. Function to withdraw (decrease balance)
5. Function to check balance
6. Use appropriate data types for each variable

**Bonus**: Add events for deposits and withdrawals (we'll cover events in Module 6)

### Starter Code

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract SimpleBank {
    // Your code here
}
```

---

## ✅ Completion Checklist

Before moving to Module 2, ensure you can:

- [ ] Explain the difference between `uint256` and `int256`
- [ ] Declare variables of each primitive type
- [ ] Understand what a mapping is and how to use it
- [ ] Explain why underflow happens with uint256
- [ ] Complete at least 3 exercises above
- [ ] Run tests successfully with `forge test`

---

## 📚 Additional Practice

Want more practice? Try these:

1. Modify the `Counter.sol` contract to add a `decrement()` function safely
2. Create a `StudentRegistry` contract that tracks student names and ages
3. Experiment with different uint sizes (uint8, uint32, uint64) and compare gas costs

---

**Ready for the next module?** → [Go to Module 2](../module-2/README.md)
