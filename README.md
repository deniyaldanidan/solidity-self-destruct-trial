# `selfdestruct` attack trials

learned from [cyfrin-glossary](https://www.cyfrin.io/glossary/self-destruct-hack-solidity-code-example)

## Description

The `selfdestruct` keyword in Solidity is used to **permanently delete a contract** from the blockchain and **send all of its remaining Ether to a specified address**.

---

## 🧨 What It Does:

1. **Deletes the contract's code and storage** from the Ethereum blockchain.
2. **Sends any remaining ETH** in the contract to a given address.
3. Makes the contract's address unusable for any further calls (although its address and transaction history still remain on-chain).

---

### 🧪 Syntax:

```solidity
selfdestruct(payableAddress);
```

- `payableAddress`: The address that will receive the remaining Ether.

---

### 🧱 Example:

```solidity
contract Killable {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function kill() external {
        require(msg.sender == owner, "Not the owner");
        selfdestruct(owner);
    }

    receive() external payable {}
}
```

Here:

- The contract can receive ETH.
- Only the `owner` can call `kill()`.
- When `kill()` is called, the contract is deleted and the remaining ETH is sent to the owner.

---

### ⚠️ Important Notes:

| Point              | Description                                                                                                                                                                   |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 🚫 Code deletion   | After `selfdestruct`, the contract code is gone; calling it returns empty responses.                                                                                          |
| 🧊 No resurrection | You cannot redeploy the exact same contract at the same address (unless via create2).                                                                                         |
| 🔒 Access control  | Always protect `selfdestruct` with a condition (like `onlyOwner`) to avoid malicious shutdowns.                                                                               |
| 🔍 Still visible   | All past transactions and the address remain visible on-chain.                                                                                                                |
| 💥 Risky to use    | Often considered bad practice now unless absolutely necessary. Ethereum core devs may deprecate it in the future (e.g., [EIP-4758](https://eips.ethereum.org/EIPS/eip-4758)). |

---
