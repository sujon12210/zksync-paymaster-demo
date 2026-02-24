# zkSync Paymaster Demo

This repository demonstrates the power of native Account Abstraction on zkSync. It includes a custom Paymaster contract that intercepts transactions and allows for alternative gas payment methods.

## Features
* **ERC20 Gas Payment:** Users can pay for transactions using USDC or any designated token.
* **Native AA Integration:** Built specifically for zkSync Era's unique account abstraction architecture.
* **Gas Estimation Logic:** Includes helper scripts to calculate the required token amount based on current ETH gas prices.
* **Security Checks:** Validates signatures and token balances before sponsoring transactions.

## Prerequisites
* Node.js and Yarn/NPM
* Foundational knowledge of Solidity and zkSync Era
* A wallet with Sepolia ETH on zkSync for testing

## Quick Start
1. Install dependencies: `npm install`
2. Compile contracts: `npm run compile`
3. Deploy to zkSync Sepolia: `node deploy-paymaster.js`
