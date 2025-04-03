// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A simple contract to store and retrieve a value
/// @notice This demonstrates basic Solidity syntax and state variables
contract SimpleStorage {
    // State variable - stored permanently in contract storage
    uint256 private storedData;
    
    // Event declaration - allows clients to react to specific contract changes
    event DataStored(address indexed _from, uint256 _value);
    
    // Constructor - called once when the contract is deployed
    constructor() {
        storedData = 0;
    }
    
    /// @notice Store a new value in the contract
    /// @param _value The new value to store
    function set(uint256 _value) public {
        storedData = _value;
        // Emit an event when data is stored
        emit DataStored(msg.sender, _value);
    }
    
    /// @notice Get the stored value
    /// @return The stored value
    function get() public view returns (uint256) {
        return storedData;
    }
    
    /// @notice Increment the stored value by 1
    function increment() public {
        storedData += 1;
        emit DataStored(msg.sender, storedData);
    }
    
    /// @notice Decrement the stored value by 1
    /// @dev This function includes a check to prevent underflow
    function decrement() public {
        // Check to prevent underflow
        require(storedData > 0, "Cannot decrement below zero");
        storedData -= 1;
        emit DataStored(msg.sender, storedData);
    }
} 