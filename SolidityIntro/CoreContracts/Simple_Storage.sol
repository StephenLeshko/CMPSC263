// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SimpleStorage
 * @dev A basic contract for beginners that demonstrates storing and retrieving a simple value
 * 
 * GAS NOTES:
 * - Deploying this contract costs gas (one-time fee)
 * - Reading data with 'get()' is free when called externally (view function)
 * - Writing data with 'set()' costs gas as it changes blockchain state
 */
contract SimpleStorage {
    // This is a state variable - stored permanently on the blockchain
    // Public variables automatically get a "getter" function
    // GAS COST: Each state variable costs gas to initialize and modify
    uint public storedData;

    /**
     * @dev Constructor runs only once when the contract is deployed
     * @param initialValue The starting value for storedData
     * 
     * GAS COST: Constructor execution is part of deployment cost
     */
    constructor(uint initialValue) {
        storedData = initialValue;
    }

    /**
     * @dev Updates the stored value
     * @param x The new value to store
     * 
     * GAS COST: This function costs gas because:
     * 1. It modifies state data on the blockchain
     * 2. The more complex the operation, the more gas it costs
     */
    function set(uint x) public {
        storedData = x;
    }

    /**
     * @dev Retrieves the stored value
     * @return The current value of storedData
     * 
     * GAS COST: This function is free when called externally because:
     * 1. It's marked as 'view' (doesn't modify state)
     * 2. It only reads data, doesn't write anything
     */
    function get() public view returns (uint) {
        return storedData;
    }
}