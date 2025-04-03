# Gas Optimization and Security Best Practices
## CMPSC 263 - Blockchain and Modern Web Development

This guide provides an overview of gas costs in Solidity and essential security best practices to follow when developing smart contracts.

## Understanding Gas in Ethereum

### What is Gas?

Gas is the fee required to execute operations on the Ethereum blockchain. Every computation, storage operation, and transaction on Ethereum costs gas.

- **Gas Limit**: Maximum amount of gas you're willing to spend on a transaction
- **Gas Price**: Amount of Ether you're willing to pay per unit of gas (in gwei)
- **Transaction Fee** = Gas Used × Gas Price

### Why Gas Matters

1. **Cost**: Real money is spent on gas fees
2. **Transaction Failures**: If you don't provide enough gas, your transaction will fail but still cost gas
3. **Block Limits**: Ethereum blocks have gas limits, so highly inefficient contracts may be unusable

## Gas Costs by Operation Type

From least expensive to most expensive:

1. **Reading State**: View/pure function calls (free when called externally)
2. **Arithmetic Operations**: Addition, subtraction, etc.
3. **Comparison Operations**: Greater than, less than, etc.
4. **Emitting Events**: Moderate cost, but cheaper than storage
5. **Writing to Memory**: Temporary storage during function execution
6. **Writing to Storage**: Most expensive operation - permanently storing data on the blockchain

### Approximate Gas Costs (as of 2023)

| Operation                   | Approximate Gas |
|-----------------------------|-----------------|
| Reading state variable      | 0 (externally)  |
| Basic arithmetic            | 3-5             |
| Emitting an event           | 375+            |
| Creating a contract         | 32,000+         |
| Storing a 256-bit word      | 20,000+ (first time) |
| Modifying storage           | 5,000+          |
| External function call      | 700+            |
| Transfer ETH                | 21,000+         |

## Gas Optimization Techniques

### 1. Storage Optimization

```solidity
// EXPENSIVE: Using multiple uint256 variables
uint256 public a;
uint256 public b;
uint256 public c;

// CHEAPER: Packing variables into a single storage slot
// Variables smaller than 32 bytes can be packed together
uint128 public a;
uint64 public b;
uint64 public c;
```

### 2. Use Events Instead of Storage When Possible

```solidity
// EXPENSIVE: Storing transaction history in an array
address[] public transactionHistory;

function transfer(address to, uint256 amount) public {
    // ... transfer logic ...
    transactionHistory.push(to);  // Expensive storage operation
}

// CHEAPER: Using events for historical data
event Transfer(address indexed from, address indexed to, uint256 amount);

function transfer(address to, uint256 amount) public {
    // ... transfer logic ...
    emit Transfer(msg.sender, to, amount);  // Cheaper than storage
}
```

### 3. Function Visibility

```solidity
// EXPENSIVE: Public functions create accessor functions
uint256[] public values;

// CHEAPER: Use external for functions only called externally
function processValues(uint256[] calldata _values) external {
    // 'calldata' is cheaper than 'memory' for external functions
}
```

### 4. Avoid Unnecessary Loops

```solidity
// EXPENSIVE: Unbounded loop could cost too much gas
function processAll() public {
    for (uint i = 0; i < items.length; i++) {
        // Process each item
    }
}

// CHEAPER: Process in batches
function processBatch(uint256 startIndex, uint256 batchSize) public {
    uint256 endIndex = startIndex + batchSize;
    require(endIndex <= items.length, "Out of bounds");
    
    for (uint i = startIndex; i < endIndex; i++) {
        // Process each item
    }
}
```

## Security Best Practices

### 1. Checks-Effects-Interactions Pattern

Always follow this pattern to prevent reentrancy attacks:

```solidity
// VULNERABLE to reentrancy
function withdraw(uint256 amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // DANGER: External call before state update
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
    
    // State update happens too late
    balances[msg.sender] -= amount;
}

// SECURE implementation
function withdraw(uint256 amount) public {
    // 1. Checks
    require(balances[msg.sender] >= amount, "Insufficient balance");
    
    // 2. Effects (state changes)
    balances[msg.sender] -= amount;
    
    // 3. Interactions (external calls)
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

### 2. Use Reentrancy Guards

```solidity
bool private locked;

modifier noReentrancy() {
    require(!locked, "No reentrancy");
    locked = true;
    _;
    locked = false;
}

function withdraw(uint256 amount) public noReentrancy {
    // Function body
}
```

### 3. Be Careful with External Calls

- Always assume external calls can fail
- Set gas limits for external calls
- Don't rely on external contract behavior

### 4. Avoid tx.origin for Authentication

```solidity
// VULNERABLE: Using tx.origin
function transfer(address to, uint amount) public {
    require(tx.origin == owner, "Not authorized");
    // Transfer logic
}

// SECURE: Use msg.sender instead
function transfer(address to, uint amount) public {
    require(msg.sender == owner, "Not authorized");
    // Transfer logic
}
```

### 5. Integer Overflow/Underflow

Solidity 0.8.0+ has built-in overflow checking, but for earlier versions:

```solidity
// VULNERABLE in Solidity <0.8.0
function add(uint256 a, uint256 b) public pure returns (uint256) {
    return a + b;  // Could overflow
}

// SECURE for Solidity <0.8.0
function add(uint256 a, uint256 b) public pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "Overflow");
    return c;
}
```

### 6. Proper Access Control

```solidity
address public owner;

modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;
}

function sensitiveFunction() public onlyOwner {
    // Only owner can call this
}
```

### 7. Don't Rely on Block Values for Randomness

```solidity
// VULNERABLE: Miners can manipulate these values
function generateRandom() public view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
}
```

### 8. Use SafeMath for Solidity <0.8.0

```solidity
// For Solidity <0.8.0, use SafeMath library
using SafeMath for uint256;

function add(uint256 a, uint256 b) public pure returns (uint256) {
    return a.add(b);  // Safe from overflow
}
```

## Common Security Vulnerabilities to Watch For

1. **Reentrancy Attacks**: External calls allowing multiple withdrawals before balance updates
2. **Front-Running**: Attackers seeing pending transactions and inserting their own first
3. **Timestamp Manipulation**: Block timestamps can be manipulated by miners
4. **Integer Overflow/Underflow**: Exceeding type limits causing wrap-around
5. **Denial of Service**: Making functions too expensive to call or impossible to execute
6. **Logic Errors**: Flawed business logic in the contract
7. **Access Control Issues**: Missing or improperly implemented access controls

## Final Recommendations

1. **Test Thoroughly**: Use unit tests and test networks
2. **Code Review**: Have others review your code
3. **Formal Verification**: For high-value contracts
4. **Use Audited Libraries**: Like OpenZeppelin
5. **Start Small**: Deploy to testnet first, then with small amounts
6. **Emergency Stop**: Implement circuit breakers for emergencies
7. **Monitor Activity**: Watch deployed contracts for unusual activity 