# Solidity Syntax Guide
## CMPSC 263 - Blockchain and Modern Web Development

This guide provides a quick reference to Solidity syntax and concepts covered in class.

## Basic Contract Structure

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    // State variables
    // Functions
    // Events
    // Modifiers
    // Etc.
}
```

## Comments

```solidity
// This is a single-line comment

/*
This is a
multi-line comment
*/

/// @title This is a NatSpec comment (used for documentation)
/// @author Class Instructor
/// @notice Explains to users what the contract does
/// @dev Explains to developers complex implementation details
```

## Data Types

### Value Types

```solidity
// Booleans
bool public isReady = true;

// Integers
int8 public smallNumber = -128; // Signed 8-bit integer (-128 to 127)
uint8 public smallUnsignedNumber = 255; // Unsigned 8-bit integer (0 to 255)
int256 public bigNumber = -1234567890; // Signed 256-bit integer
uint256 public bigUnsignedNumber = 1234567890; // Unsigned 256-bit integer
uint public defaultUint = 123; // uint is an alias for uint256

// Address
address public userAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
address payable public payableAddress = payable(userAddress); // Can receive Ether

// Bytes
bytes1 public singleByte = 0xFF; // Fixed-size byte array
bytes public dynamicBytes = "hello"; // Dynamic-size byte array

// String
string public greeting = "Hello, Solidity!";
```

### Reference Types

```solidity
// Arrays
uint[] public dynamicArray; // Dynamic array
uint[5] public fixedArray; // Fixed-size array

// Structs
struct Person {
    string name;
    uint age;
    address wallet;
}
Person public person1 = Person("Alice", 25, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

// Mappings (key-value pairs)
mapping(address => uint) public balances; // Maps addresses to balances
mapping(address => mapping(address => bool)) public approved; // Nested mapping
```

## Variables

### State Variables

```solidity
contract VariableDemo {
    // State variables are stored on the blockchain
    uint256 public stateVariable = 100; // Public creates an automatic getter function
    uint256 internal internalVar = 200; // Available to this contract and derived contracts
    uint256 private privateVar = 300; // Only available in this contract
}
```

### Local Variables

```solidity
function localVarExample() public pure returns (uint) {
    // Local variables only exist during function execution
    uint256 localVar = 500;
    return localVar;
}
```

## Functions

### Function Structure

```solidity
function functionName(
    uint256 _parameter1,
    string memory _parameter2
) 
    public // Visibility
    payable // Can receive Ether
    returns (uint256, string memory) // Return types
{
    // Function body
    return (123, "result");
}
```

### Function Visibility

```solidity
// Public: Accessible from this contract, derived contracts, and other contracts and externally
function publicFunction() public {}

// Private: Only accessible from this contract
function privateFunction() private {}

// Internal: Accessible from this contract and derived contracts
function internalFunction() internal {}

// External: Only callable from other contracts and externally
function externalFunction() external {}
```

### Function Modifiers

```solidity
// View: Doesn't modify state (free when called externally)
function viewFunction() public view returns (uint) {
    return stateVariable;
}

// Pure: Doesn't access or modify state (free when called externally)
function pureFunction(uint a, uint b) public pure returns (uint) {
    return a + b;
}

// Payable: Can receive Ether with the call
function payableFunction() public payable {
    // msg.value contains the ether sent
}
```

### Custom Modifiers

```solidity
// State variable
address public owner;

// Constructor sets the owner
constructor() {
    owner = msg.sender;
}

// Custom modifier
modifier onlyOwner {
    require(msg.sender == owner, "Not the owner");
    _; // Continue executing the function
}

// Using the modifier
function privilegedFunction() public onlyOwner {
    // Only the owner can execute this
}
```

## Error Handling

```solidity
function requireExample(uint _value) public {
    // Validates condition and reverts if false
    require(_value > 100, "Value must be greater than 100");
    
    // If condition passes, execution continues
}

function revertExample(uint _value) public {
    // Equivalent to require but sometimes more gas-efficient
    if (_value <= 100) {
        revert("Value must be greater than 100");
    }
    
    // If no revert, execution continues
}

function assertExample(uint a, uint b) public pure {
    // Used for internal errors that should never happen
    assert(a + b >= a); // Should never fail unless there's an overflow
}
```

## Events

```solidity
// Declaring an event
event Transfer(address indexed from, address indexed to, uint256 value);

// Emitting an event
function transfer(address _to, uint256 _value) public {
    // Logic for transfer...
    
    // Emit the event
    emit Transfer(msg.sender, _to, _value);
}
```

## Special Variables and Functions

```solidity
function specialVars() public view returns (
    address, uint, uint, uint, bytes memory
) {
    return (
        msg.sender,        // Address that called the function
        msg.value,         // Amount of ETH sent (in wei)
        block.number,      // Current block number
        block.timestamp,   // Current block timestamp
        msg.data           // Complete calldata
    );
}
```

## Memory vs Storage

```solidity
// Storage - persistent between function calls (state variables)
uint[] public storageArray;

function useStorage() public {
    // This modifies the state variable (storage)
    storageArray.push(100);
}

function useMemory(uint[] memory memoryArray) public {
    // memoryArray is temporary and exists only during function execution
    memoryArray[0] = 100; // Only modifies the memory copy
}
```

## Inheritance

```solidity
// Base contract
contract Parent {
    uint internal parentVar;
    
    function parentFunction() public virtual {
        // Implementation
    }
}

// Derived contract
contract Child is Parent {
    // Override parent function
    function parentFunction() public override {
        // New implementation
    }
}

// Multiple inheritance
contract MultiChild is Parent, AnotherParent {
    // Must resolve function name conflicts
}
```

## Advanced Features

```solidity
// Interfaces
interface IToken {
    function transfer(address to, uint amount) external returns (bool);
}

// Using an interface
function useToken(address tokenAddress) public {
    IToken token = IToken(tokenAddress);
    token.transfer(msg.sender, 100);
}

// Libraries
library Math {
    function max(uint a, uint b) internal pure returns (uint) {
        return a >= b ? a : b;
    }
}

// Using a library
function useLibrary() public pure returns (uint) {
    return Math.max(10, 20);
}
```

## Best Practices

1. **Always specify the visibility** of functions and state variables
2. **Use require statements** to validate inputs and conditions
3. **Emit events** for state changes to help clients track activities
4. **Be mindful of gas costs** - storage operations are expensive
5. **Follow the Checks-Effects-Interactions pattern** to prevent reentrancy attacks
6. **Don't trust user inputs** - always validate
7. **Keep contracts simple** - complexity increases risk
8. **Use NatSpec comments** for better documentation
9. **Be careful with `delegatecall`** - it can be dangerous
10. **Test thoroughly** before deploying to mainnet 