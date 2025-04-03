# Deploying Solidity Smart Contracts
## CMPSC 263 - Blockchain and Modern Web Development

This guide covers the basics of deploying and interacting with Solidity smart contracts using Remix IDE and other tools.

## Using Remix IDE

[Remix IDE](https://remix.ethereum.org) is a web-based IDE for Solidity development that requires no installation.

### Step 1: Open Remix IDE

Navigate to [remix.ethereum.org](https://remix.ethereum.org) in your browser.

### Step 2: Create or Import a Contract

1. Click on the "File Explorer" icon in the left sidebar
2. Click the "+" icon to create a new file (e.g., "SimpleStorage.sol")
3. Paste your contract code into the editor

### Step 3: Compile the Contract

1. Click on the "Solidity Compiler" icon in the left sidebar
2. Select the appropriate compiler version (matching your pragma statement)
3. Click "Compile SimpleStorage.sol"

### Step 4: Deploy the Contract

1. Click on the "Deploy & Run Transactions" icon in the left sidebar
2. Choose an environment:
   - JavaScript VM (for local testing)
   - Injected Web3 (for connecting via MetaMask to networks like Ethereum mainnet or testnets)
   - Web3 Provider (for connecting to a local node)
3. Select the contract you want to deploy from the dropdown
4. Click the "Deploy" button
5. If your constructor requires parameters, enter them before deployment

### Step 5: Interact with the Contract

1. Once deployed, your contract will appear in the "Deployed Contracts" section
2. Expand the contract to see all available functions
3. Click on functions to call them:
   - Blue buttons are for view/pure functions (no gas cost)
   - Orange buttons are for state-changing functions (requires gas)
   - Red buttons are for functions that can receive Ether (payable)

## Using Hardhat (Advanced)

Hardhat is a development environment for Ethereum software that enables professional workflows.

### Setup Hardhat Project

```bash
# Create a new directory for your project
mkdir my-solidity-project
cd my-solidity-project

# Initialize a new npm project
npm init -y

# Install Hardhat
npm install --save-dev hardhat

# Initialize Hardhat
npx hardhat
```

### Deploy with Hardhat

1. Write your contract in the `contracts/` folder
2. Create a deployment script in the `scripts/` folder
3. Configure networks in `hardhat.config.js`
4. Deploy with:

```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

## Using Truffle (Advanced)

Truffle is a development environment, testing framework, and asset pipeline for Ethereum.

### Setup Truffle Project

```bash
# Install Truffle globally
npm install -g truffle

# Create a new Truffle project
mkdir truffle-project
cd truffle-project
truffle init
```

### Deploy with Truffle

1. Write your contract in the `contracts/` folder
2. Create a migration script in the `migrations/` folder
3. Configure networks in `truffle-config.js`
4. Deploy with:

```bash
truffle migrate --network <network-name>
```

## Interacting with Contracts from Web Apps

### Using ethers.js

```javascript
// Import ethers.js
import { ethers } from "ethers";

// Connect to the network
const provider = new ethers.providers.Web3Provider(window.ethereum);
await provider.send("eth_requestAccounts", []);
const signer = provider.getSigner();

// Contract ABI and address
const contractABI = [...]; // Your contract ABI
const contractAddress = "0x..."; // Your contract address

// Create contract instance
const contract = new ethers.Contract(contractAddress, contractABI, signer);

// Call contract functions
const value = await contract.get(); // Call view function
const tx = await contract.set(42); // Call state-changing function
await tx.wait(); // Wait for transaction to be mined
```

### Using web3.js

```javascript
// Import web3.js
import Web3 from "web3";

// Connect to the network
const web3 = new Web3(window.ethereum);
await window.ethereum.enable();

// Contract ABI and address
const contractABI = [...]; // Your contract ABI
const contractAddress = "0x..."; // Your contract address

// Create contract instance
const contract = new web3.eth.Contract(contractABI, contractAddress);

// Call contract functions
const accounts = await web3.eth.getAccounts();
const value = await contract.methods.get().call(); // Call view function
await contract.methods.set(42).send({ from: accounts[0] }); // Call state-changing function
```

## Testing Networks

Before deploying to the Ethereum mainnet, test your contracts on these networks:

1. **JavaScript VM** in Remix - Local, no real ETH needed
2. **Sepolia** - Ethereum testnet, requires testnet ETH
   - Get testnet ETH from a faucet like [sepoliafaucet.com](https://sepoliafaucet.com/)
3. **Goerli** - Another Ethereum testnet
4. **Hardhat Network** - Local development network (with Hardhat)
5. **Ganache** - Local development blockchain (with Truffle)

## Gas Optimization Tips

Smart contracts cost real money to deploy and execute. Here are some tips:

1. Minimize storage usage - storage operations are expensive
2. Batch operations when possible
3. Use events instead of storing data that's only needed off-chain
4. Use `view` and `pure` functions when possible
5. Use `external` instead of `public` for functions called from outside
6. Avoid unnecessary computations
7. Use bytes32 instead of string when possible

## Security Best Practices

1. Always use the latest Solidity version
2. Follow the Checks-Effects-Interactions pattern
3. Use `SafeMath` for Solidity versions < 0.8.0
4. Avoid using `tx.origin` for authentication
5. Be careful with `delegatecall`
6. Consider using OpenZeppelin contracts
7. Get your contracts audited before mainnet deployment 