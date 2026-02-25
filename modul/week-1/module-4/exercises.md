# Module 4: Exercises

## Practice Tasks for Bytes & Encoding

---

## Exercise 4.1: Basic Encoding/Decoding ⭐

**Difficulty**: Easy  
**Time**: 15 minutes

### Task

Create an `Encoder.sol` contract that can:
1. Encode multiple data types into bytes
2. Decode bytes back to original types
3. Store encoded data and retrieve it

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract Encoder {
    bytes public storedData;
    
    event DataEncoded(bytes encoded);
    event DataDecoded(string text, address addr, uint256 number);
    
    /// @notice Encode data into bytes
    function encodeData(
        string memory text,
        address addr,
        uint256 number
    ) public pure returns (bytes memory) {
        return abi.encode(text, addr, number);
    }
    
    /// @notice Decode bytes back to original types
    function decodeData(bytes calldata data) 
        public 
        pure 
        returns (string memory, address, uint256) 
    {
        return abi.decode(data, (string, address, uint256));
    }
    
    /// @notice Store encoded data
    function storeEncoded(
        string memory text,
        address addr,
        uint256 number
    ) public {
        storedData = abi.encode(text, addr, number);
        emit DataEncoded(storedData);
    }
    
    /// @notice Retrieve and decode stored data
    function getStoredData() 
        public 
        view 
        returns (string memory, address, uint256) 
    {
        (string memory text, address addr, uint256 number) = 
            abi.decode(storedData, (string, address, uint256));
        
        emit DataDecoded(text, addr, number);
        return (text, addr, number);
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Encoder} from "@src/week1/Encoder.sol";

contract EncoderTest is Test {
    Encoder public encoder;
    
    function setUp() public {
        encoder = new Encoder();
    }
    
    function testEncodeDecode() public {
        string memory text = "Hello";
        address addr = address(0x123);
        uint256 number = 100;
        
        bytes memory encoded = encoder.encodeData(text, addr, number);
        (string memory decodedText, address decodedAddr, uint256 decodedNum) = 
            encoder.decodeData(encoded);
        
        assertEq(decodedText, text);
        assertEq(decodedAddr, addr);
        assertEq(decodedNum, number);
    }
    
    function testStoreAndRetrieve() public {
        encoder.storeEncoded("World", address(0x456), 200);
        
        (string memory text, address addr, uint256 number) = 
            encoder.getStoredData();
        
        assertEq(text, "World");
        assertEq(addr, address(0x456));
        assertEq(number, 200);
    }
}
```

</details>

---

## Exercise 4.2: Encode vs EncodePacked Gas Comparison ⭐⭐

**Difficulty**: Medium  
**Time**: 20 minutes

### Task

Create a contract that demonstrates the gas difference between `encode` and `encodePacked`. Use `forge test --gas-report` to compare.

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract GasComparison {
    function encodeAndHash(string memory a, string memory b) 
        public 
        pure 
        returns (bytes32) 
    {
        return keccak256(abi.encode(a, b));
    }
    
    function encodePackedAndHash(string memory a, string memory b) 
        public 
        pure 
        returns (bytes32) 
    {
        return keccak256(abi.encodePacked(a, b));
    }
    
    // Function to show collision possibility
    function demonstrateCollision() public pure returns (bool) {
        string memory a = "AB";
        string memory b = "C";
        string memory c = "A";
        string memory d = "BC";
        
        // With encodePacked, these produce the same hash!
        bytes32 hash1 = keccak256(abi.encodePacked(a, b));
        bytes32 hash2 = keccak256(abi.encodePacked(c, d));
        
        return hash1 == hash2;  // true - collision!
    }
    
    function noCollisionWithEncode() public pure returns (bool) {
        string memory a = "AB";
        string memory b = "C";
        string memory c = "A";
        string memory d = "BC";
        
        // With encode, these produce different hashes
        bytes32 hash1 = keccak256(abi.encode(a, b));
        bytes32 hash2 = keccak256(abi.encode(c, d));
        
        return hash1 != hash2;  // true - no collision!
    }
}
```

**Run gas report**:
```bash
forge test --gas-report
```

</details>

---

## Exercise 4.3: Cross-Chain Message Simulator ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 35 minutes

### Task

Create a `CrossChainBridge.sol` contract that simulates cross-chain messaging:
1. Encode messages on "source chain"
2. "Bridge" relays the encoded message
3. "Destination chain" decodes and processes the message

### Requirements

- Use `abi.encode()` for the message payload
- Include sender, recipient, amount, and message
- Emit events for tracking
- Handle errors gracefully

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract CrossChainBridge {
    error InvalidPayload();
    error NotBridge();
    
    event MessageSent(
        uint256 indexed nonce,
        uint256 destinationChainId,
        bytes payload
    );
    
    event MessageReceived(
        uint256 indexed nonce,
        address sender,
        address recipient,
        uint256 amount,
        string message
    );
    
    mapping(uint256 => bytes) public messages;
    mapping(address => bool) public isBridge;
    uint256 public nonce;
    
    modifier onlyBridge() {
        _onlyBridge();
        _;
    }
    
    constructor(address[] memory bridges) {
        for (uint256 i = 0; i < bridges.length; i++) {
            isBridge[bridges[i]] = true;
        }
    }
    
    /// @notice Send a cross-chain message
    function sendMessage(
        uint256 destinationChainId,
        address sender,
        address recipient,
        uint256 amount,
        string calldata message
    ) public returns (uint256) {
        // Encode the payload
        bytes memory payload = abi.encode(sender, recipient, amount, message);
        
        uint256 messageNonce = ++nonce;
        messages[messageNonce] = payload;
        
        emit MessageSent(messageNonce, destinationChainId, payload);
        
        return messageNonce;
    }
    
    /// @notice Receive and process a cross-chain message
    function receiveMessage(
        uint256 messageNonce,
        bytes calldata payload
    ) public onlyBridge {
        // Decode the payload
        (address sender, address recipient, uint256 amount, string memory message) = 
            abi.decode(payload, (address, address, uint256, string));
        
        emit MessageReceived(messageNonce, sender, recipient, amount, message);
        
        // Process the message (e.g., transfer tokens)
        // balances[recipient] += amount;
    }
    
    function _onlyBridge() internal view {
        if (!isBridge[msg.sender]) revert NotBridge();
    }
}
```

**Test file**:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {CrossChainBridge} from "@src/week1/CrossChainBridge.sol";

contract CrossChainBridgeTest is Test {
    CrossChainBridge public bridge;
    address public bridgeRelay = makeAddr("bridgeRelay");
    
    function setUp() public {
        address[] memory bridges = new address[](1);
        bridges[0] = bridgeRelay;
        bridge = new CrossChainBridge(bridges);
    }
    
    function testSendMessage() public {
        uint256 nonce = bridge.sendMessage(
            1,  // destination chain ID
            address(this),  // sender
            address(0x123),  // recipient
            1000,  // amount
            "Hello from chain 1"  // message
        );
        
        assertEq(nonce, 1);
    }
    
    function testReceiveMessage() public {
        // First send
        bytes memory payload = abi.encode(
            address(this),
            address(0x123),
            1000,
            "Hello"
        );
        
        // Then receive (as bridge)
        vm.startPrank(bridgeRelay);
        bridge.receiveMessage(1, payload);
        vm.stopPrank();
    }
}
```

</details>

---

## Exercise 4.4: Signature Verification ⭐⭐

**Difficulty**: Medium  
**Time**: 25 minutes

### Task

Create a `SignatureVerifier.sol` contract that:
1. Encodes message data for signing
2. Verifies signatures using `ecrecover`
3. Uses `abi.encodePacked` for hash generation

### Solution

<details>
<summary>Click to reveal solution</summary>

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

contract SignatureVerifier {
    error InvalidSignature();
    error InvalidSigner();
    
    /// @notice Get the hash of encoded data for signing
    function getMessageHash(
        address from,
        address to,
        uint256 amount,
        uint256 nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(from, to, amount, nonce));
    }
    
    /// @notice Get the Ethereum signed message hash
    function getEthSignedMessageHash(bytes32 messageHash) 
        public 
        pure 
        returns (bytes32) 
    {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );
    }
    
    /// @notice Recover signer from signature
    function verifySignature(
        address from,
        address to,
        uint256 amount,
        uint256 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s,
        address expectedSigner
    ) public pure {
        bytes32 messageHash = getMessageHash(from, to, amount, nonce);
        bytes32 ethSignedHash = getEthSignedMessageHash(messageHash);
        
        address signer = ecrecover(ethSignedHash, v, r, s);
        
        if (signer != expectedSigner) revert InvalidSigner();
    }
}
```

</details>

---

## ✅ Completion Checklist

Before moving to Module 5, ensure you can:

- [ ] Explain the difference between `bytes`, `bytes32`, and `string`
- [ ] Use `abi.encode()` and `abi.decode()` correctly
- [ ] Understand when to use `encodePacked()` vs `encode()`
- [ ] Optimize gas costs with `calldata` for bytes parameters
- [ ] Complete at least 2 exercises above

---

## 🎯 Challenge: Encoded Multi-Sig Wallet ⭐⭐⭐

**Difficulty**: Hard  
**Time**: 45 minutes

### Task

Build an `EncodedMultiSig.sol` wallet where:
1. Transaction data is encoded into bytes
2. Multiple signatures are required
3. Signatures are verified using encoded transaction hash

**Requirements:**
- Encode transaction data (to, value, data)
- Collect multiple signatures
- Verify signatures before execution
- Emit events with encoded data

---

**Ready for the next module?** → [Go to Module 5](../module-5/README.md)
