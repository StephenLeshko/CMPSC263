// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ConstructorAndFallback
 * @dev A simple contract demonstrating both constructor and fallback functionality
 */
contract ConstructorAndFallback {
    // State variables
    address public owner;
    uint256 public creationTime;
    uint256 public lastCallValue;
    uint256 public fallbackCallCount;
    string public lastFunctionCalled;
    
    // Events for monitoring contract activity
    event FallbackCalled(address sender, uint256 value);
    event ReceiveCalled(address sender, uint256 value);
    
    /**
     * @dev Constructor - runs ONCE during contract deployment
     * 
     * The constructor:
     * - Is executed only once when the contract is created
     * - Cannot be called after deployment
     * - Is used to initialize contract state
     * - Doesn't need the "function" keyword
     */
    constructor() {
        // Set the deployer as the owner
        owner = msg.sender;
        
        // Record when the contract was created
        creationTime = block.timestamp;
        
        // Initialize tracking variables
        fallbackCallCount = 0;
        lastFunctionCalled = "constructor";
    }
    
    /**
     * @dev Simple function that can be called normally
     */
    function doSomething() public {
        lastFunctionCalled = "doSomething";
    }
    
    /**
     * @dev Fallback function - called when:
     * 1. A function that doesn't exist is called, or
     * 2. Data is sent with the transaction but doesn't match any function
     * 
     * The fallback function:
     * - Has no name (just "fallback")
     * - Must be external
     * - Can be payable (to receive Ether)
     * - Has limited gas (2300) when called during Ether transfer
     */
    fallback() external payable {
        // Track that fallback was called
        fallbackCallCount++;
        lastCallValue = msg.value;
        lastFunctionCalled = "fallback";
        
        // Emit event
        emit FallbackCalled(msg.sender, msg.value);
    }
    
    /**
     * @dev Receive function - called when:
     * Ether is sent to the contract without any data
     * 
     * The receive function:
     * - Must be external payable
     * - Cannot have arguments
     * - Cannot return anything
     * - Has limited gas (2300) when called via .send() or .transfer()
     */
    receive() external payable {
        // Track that receive was called
        lastCallValue = msg.value;
        lastFunctionCalled = "receive";
        
        // Emit event
        emit ReceiveCalled(msg.sender, msg.value);
    }
    
    /**
     * @dev Check contract balance
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Allows the owner to withdraw funds
     */
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        
        // Transfer all balance to the owner
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }
}

/**
 * HOW TO TEST THIS CONTRACT:
 * 
 * 1. Deploy the contract - constructor will run automatically
 * 2. Send Ether to the contract address without calling any function -> receive() will be called
 * 3. Call a non-existent function or send data that doesn't match any function -> fallback() will be called
 * 4. Call doSomething() -> updates lastFunctionCalled
 * 5. Check the values of lastFunctionCalled and fallbackCallCount to see what was triggered
 */ 