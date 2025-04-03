# Omar's Solidity Example Contracts
## CMPSC 263 - Blockchain and Modern Web Development

This folder contains example Solidity contracts to demonstrate different token standards and blockchain development concepts.

## Contracts Overview

1. **Simple_Storage.sol** - Basic storage contract demonstrating state variables and functions
   - Shows the fundamentals of storing and retrieving data on the blockchain
   - Demonstrates gas costs for different operations

2. **Simple_Coin.sol** - A basic token implementation without following ERC20 standard
   - Shows mappings, events, and custom errors
   - Implements a simple token system from scratch

3. **Sample_ERC20.sol** - Standard ERC20 token using OpenZeppelin
   - Demonstrates creating a fungible token following the ERC20 standard
   - Shows contract inheritance and extensions (burnable, pausable, voting)

4. **ERC721_Simple.sol** - NFT (Non-Fungible Token) implementation
   - Shows how to create unique tokens following the ERC721 standard
   - Demonstrates tokenURI and metadata handling

## Using These Contracts

### Option 1: Remix IDE (Easiest for Beginners)

1. Go to [Remix IDE](https://remix.ethereum.org/)
2. Create a new file for each contract and paste the code
3. For contracts using OpenZeppelin:
   - Remix will automatically import the OpenZeppelin contracts
   - You may need to select the correct compiler version (0.8.20)

### Option 2: Local Development Environment

If you want to develop locally with proper OpenZeppelin dependencies:

1. Install Node.js and npm
2. Create a new project:
   ```bash
   mkdir my-token-project
   cd my-token-project
   npm init -y
   ```

3. Install Hardhat and OpenZeppelin contracts:
   ```bash
   npm install --save-dev hardhat
   npm install @openzeppelin/contracts
   ```

4. Initialize Hardhat:
   ```bash
   npx hardhat
   ```

5. Place contracts in the `contracts/` folder
6. Compile with:
   ```bash
   npx hardhat compile
   ```

## Gas Considerations

- **State Variables**: Cost gas to initialize and modify
- **Mappings**: Reading is cheap, writing is expensive
- **Events**: Cheaper than storing the same data in state variables
- **View/Pure Functions**: Free when called externally
- **Contract Size**: Larger contracts cost more gas to deploy

## Learning Resources

- [Solidity Documentation](https://docs.soliditylang.org/)
- [OpenZeppelin Docs](https://docs.openzeppelin.com/)
- [ERC20 Standard](https://eips.ethereum.org/EIPS/eip-20)
- [ERC721 Standard](https://eips.ethereum.org/EIPS/eip-721) 