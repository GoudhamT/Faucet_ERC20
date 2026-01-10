# 🪙 Token Faucet

A lightweight ERC20 token faucet deployed on the Sepolia testnet, designed to reliably distribute a fixed amount of tokens to users with built-in claim tracking and time-based validation.

This project demonstrates a complete smart contract lifecycle: local testing, deployment, on-chain verification, and real wallet interaction.

---

## 📍 Live Deployment

- **Network:** Sepolia Testnet  
- **Contract Address:**  
  `0x09096343f7527A5d2a991083238224e58d435B1D`

---

## ✨ Features

- ERC20-compliant token distribution
- Faucet-based claim mechanism
- Time-based claim validation
- Secure transfers using OpenZeppelin
- Fully tested with Foundry
- Deployed and verified on Sepolia

---

## 🛠 Tech Stack

- Solidity
- OpenZeppelin Contracts
- Foundry (forge)
- Sepolia Testnet
- MetaMask

---
## 🚀 Getting Started (Local Development)

```bash
git clone https://github.com/GoudhamT/Faucet_ERC20.git
cd Faucet_ERC20
forge install
forge build
forge test
