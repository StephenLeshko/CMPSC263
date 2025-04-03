// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Security Considerations Demo Contract
/// @notice Demonstrates common security pitfalls and best practices
contract SecurityPitfalls {
    // State variables
    address public owner;
    mapping(address => uint256) public balances;
    bool private locked;
    
    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    
    // Constructor
    constructor() {
        owner = msg.sender;
    }
    
    // Security modifier to prevent reentrancy attacks
    modifier noReentrancy() {
        require(!locked, "Reentrant call detected");
        locked = true;
        _;
        locked = false;
    }
    
    // Only owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    
    // Deposit function - receive ETH and record balance
    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // VULNERABLE FUNCTION - DO NOT USE IN PRODUCTION
    // This demonstrates a reentrancy vulnerability
    function unsafeWithdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // VULNERABILITY: State update happens after external call
        // This can enable reentrancy attacks
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
        
        // State update happens too late!
        balances[msg.sender] -= _amount;
        
        emit Withdrawal(msg.sender, _amount);
    }
    
    // SAFE FUNCTION - PROPER IMPLEMENTATION
    // Using the Checks-Effects-Interactions pattern and reentrancy guard
    function safeWithdraw(uint256 _amount) public noReentrancy {
        // Checks
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // Effects - update state before external call
        balances[msg.sender] -= _amount;
        
        // Interactions - external call last
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, _amount);
    }
    
    // VULNERABLE FUNCTION - DO NOT USE IN PRODUCTION
    // This demonstrates integer overflow (only in Solidity <0.8.0)
    function unsafeAdd(uint256 a, uint256 b) public pure returns (uint256) {
        // In Solidity <0.8.0, this would overflow without check
        // In Solidity >=0.8.0, this is protected by default
        uint256 c = a + b;
        return c;
    }
    
    // SAFE FUNCTION - PROPER IMPLEMENTATION FOR SOLIDITY <0.8.0
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256) {
        uint256 c = a + b;
        // Required for Solidity <0.8.0
        require(c >= a, "Addition overflow");
        return c;
    }
    
    // VULNERABLE FUNCTION - DO NOT USE IN PRODUCTION
    // This demonstrates tx.origin phishing
    function unsafeTransfer(address _to, uint256 _amount) public {
        // VULNERABILITY: Using tx.origin for authentication
        require(tx.origin == owner, "Not authorized");
        
        // Transfer logic...
        // This would be vulnerable to phishing attacks
    }
    
    // SAFE FUNCTION - PROPER IMPLEMENTATION
    function safeTransfer(address _to, uint256 _amount) public {
        // Using msg.sender instead of tx.origin
        require(msg.sender == owner, "Not authorized");
        
        // Transfer logic...
    }
    
    // VULNERABLE FUNCTION - DO NOT USE IN PRODUCTION
    // This demonstrates timestamp manipulation vulnerability
    function unsafeRandom() public view returns (uint256) {
        // VULNERABILITY: Using block values for randomness
        // Miners can manipulate this
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));
    }
    
    // VULNERABLE FUNCTION - DO NOT USE IN PRODUCTION
    // This demonstrates unprotected function
    function unsafeChangeOwner(address _newOwner) public {
        // VULNERABILITY: No access control
        owner = _newOwner;
    }
    
    // SAFE FUNCTION - PROPER IMPLEMENTATION
    function safeChangeOwner(address _newOwner) public onlyOwner {
        // Only the current owner can change ownership
        owner = _newOwner;
    }
    
    // Get contract balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Fallback function to receive ETH
    receive() external payable {
        deposit();
    }
} 