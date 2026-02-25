# Week 1: Solidity Fundamentals

## 🎯 Learning Path Overview

Welcome to **Week 1** of the Smart Contract Study Group! This week focuses on building a strong foundation in Solidity programming through self-paced, chunk-by-chunk learning.

---

## 📚 Module Structure

This week is divided into **6 modular chunks**, each designed to be completed in 30-60 minutes:

| Module | Topic | Time | Key Concepts |
|--------|-------|------|--------------|
| [Module 1](./module-1/README.md) | Solidity Basics & Data Types | 30-45 min | uint, int, address, bytes, state variables |
| [Module 2](./module-2/README.md) | Functions & Visibility | 30-45 min | public/external/internal/private, view/pure |
| [Module 3](./module-3/README.md) | Modifiers & Access Control | 40-50 min | onlyOwner, custom errors, constructors |
| [Module 4](./module-4/README.md) | Bytes & Encoding | 40-50 min | abi.encode, abi.decode, gas optimization |
| [Module 5](./module-5/README.md) | Structs, Enums & Mappings | 40-50 min | Complex data structures, state management |
| [Module 6](./module-6/README.md) | Events & Testing | 45-60 min | Event logging, Foundry testing, fuzzing |

---

## 🗺️ How to Use This Learning Path

### For Complete Beginners

1. **Start with Module 1** - Don't skip ahead! Each module builds on previous knowledge.
2. **Read the README** - Understand the concepts before coding.
3. **Do the exercises** - Hands-on practice is crucial.
4. **Take the quiz** - Verify your understanding (aim for 55+ points).
5. **Move to the next module** - Only when you're confident.

### For Experienced Developers

1. **Skim Module 1-2** - Review basics quickly.
2. **Focus on Module 3-6** - Deep dive into patterns and best practices.
3. **Complete all exercises** - Even if concepts are familiar.
4. **Help others** - Share your knowledge in the study group.

---

## 📖 Learning Philosophy

This learning path is designed based on **transcription insights** from experienced Solidity developers:

### Key Principles

1. **Clean Code Through Modifiers**
   > *"life changing banget, kita gak perlu ngeset setiap ini if, langsung aja taruh sini only owner"*
   
   Learn to write clean, maintainable code using modifiers instead of repetitive if-statements.

2. **Gas Optimization Awareness**
   > *"gas fee gede itu depends on komputasi programmu"*
   
   Understand gas costs from day one and write efficient contracts.

3. **Bytes for Cross-Chain**
   > *"bytes itu karena dia makan memorynya dikit terus enak"*
   
   Learn encoding/decoding for cross-chain messaging and gas optimization.

4. **Test Everything**
   > *"forge test basicnya force test ini semua yang ada di force test bakal ke unit test"*
   
   Build the habit of writing comprehensive tests.

---

## 🎯 Learning Objectives

By the end of Week 1, you will be able to:

- ✅ Declare and use all Solidity primitive data types
- ✅ Write functions with proper visibility specifiers
- ✅ Implement access control using modifiers
- ✅ Use custom errors for gas-efficient error handling
- ✅ Encode and decode data for cross-chain messages
- ✅ Create complex data structures with structs and mappings
- ✅ Emit events for off-chain tracking
- ✅ Write comprehensive Foundry tests with cheat codes
- ✅ Use fuzz testing to find edge cases

---

## 📝 Progress Tracker

Copy this template and track your progress:

```
### My Week 1 Progress

- [ ] Module 1: Basics & Data Types
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/70 points)

- [ ] Module 2: Functions & Visibility
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/75 points)

- [ ] Module 3: Modifiers & Access Control
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/75 points)

- [ ] Module 4: Bytes & Encoding
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/75 points)

- [ ] Module 5: Structs, Enums & Mappings
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/75 points)

- [ ] Module 6: Events & Testing
  - [ ] README read
  - [ ] Exercises completed (___/___)
  - [ ] Quiz passed (___/75 points)

### Notes & Questions
- Write your notes here
- List questions for the study group
```

---

## 🛠️ Setup Requirements

Before starting, ensure you have:

1. **Foundry installed**
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. **Project cloned**
   ```bash
   git clone <repository-url>
   cd study-group-sc
   ```

3. **Dependencies installed**
   ```bash
   forge install
   ```

4. **Test that everything works**
   ```bash
   forge test
   ```

---

## 📚 Additional Resources

### Recommended Reading

- **Solidity Docs**: https://docs.soliditylang.org/
- **Foundry Book**: https://book.getfoundry.sh/
- **CryptoZombies**: https://cryptozombies.io/ (Interactive Solidity tutorial)
- **Cyfrin Updraft**: https://updraft.cyfrin.io/ (Free Solidity courses)

### Tools Mentioned in Transcription

- **Swiss Knife Calldata Decoder**: https://calldata.swiss-knife.xyz/
- **LayerZero**: https://layerzero.network/ (Cross-chain messaging)
- **Chainlink**: https://chain.link/ (Oracle network)

### Communities

- Study Group Discord/Telegram
- Ethereum Developer Discord
- Solidity by Example

---

## 🎓 Assessment & Certification

### Passing Criteria

To "pass" Week 1, you should:

1. Complete all 6 module quizzes with 55+ points each
2. Complete at least 2 exercises per module
3. Be able to explain all key concepts from the transcription
4. Write a simple contract combining all learned concepts

### Final Challenge

At the end of Week 1, try to build:

**A User Management System** that includes:
- User registration with structs
- Access control with modifiers
- Events for all actions
- Comprehensive tests
- Bytes encoding for user data

---

## 💡 Tips for Success

1. **Don't Rush** - Take your time with each module. Understanding > Speed.

2. **Code Along** - Don't just read. Type out every example.

3. **Break Things** - Experiment! Change code and see what breaks.

4. **Ask Questions** - Stuck? Ask in the study group chat.

5. **Help Others** - Teaching is the best way to learn.

6. **Take Breaks** - > *"jangan belajar terus, capek nanti"*

7. **Review Regularly** - Revisit previous modules to reinforce learning.

---

## 🚀 What's After Week 1?

After completing Week 1, you'll be ready for:

- **Week 2**: Advanced Solidity Patterns
- **Week 3**: Smart Contract Security
- **Week 4**: DeFi Protocols
- **Week 5**: NFT Standards
- **Week 6**: Final Project

---

## 📞 Getting Help

If you're stuck:

1. **Re-read the module** - Often the answer is there.
2. **Check the exercises solutions** - Learn from examples.
3. **Search online** - Solidity docs, StackOverflow.
4. **Ask the community** - Post your question with code.

---

## 🎉 Ready to Start?

Begin with **[Module 1: Solidity Basics & Data Types](./module-1/README.md)**

Good luck on your Solidity journey! 🚀

---

*Last updated: February 2026*
*Based on transcription from Voice 014 & 015 study sessions*
