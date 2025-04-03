// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

/**
 * @title Coin
 * @dev A simple cryptocurrency contract for beginners demonstrating tokens
 * 
 * KEY CONCEPTS:
 * - State variables: Data stored on the blockchain
 * - Mappings: Key-value pair storage (like dictionaries/hash tables)
 * - Events: Signals that clients (frontend apps) can listen for
 * - Custom errors: Gas-efficient way to explain why a transaction failed
 */
contract Coin {
    // The keyword "public" makes variables accessible from outside the contract
    // and automatically creates a getter function
    // GAS COST: Storing this address on chain costs a small amount of gas once
    address public minter;
    
    // Mapping: A key-value store similar to a hash table or dictionary
    // This maps addresses to their coin balances
    // GAS COST: Reading from mappings is cheap, writing is expensive
    mapping(address => uint) public balances;

    // Events allow frontends and other contracts to "listen" for specific
    // contract actions. They're cheaper than storing the same data in state.
    // GAS COST: Emitting events costs less gas than storing data in state variables
    event Sent(address indexed from, address indexed to, uint amount);
    // NOTE: The "indexed" keyword allows efficient filtering of events

    // Constructor code runs ONLY ONCE when the contract is deployed
    // GAS COST: Constructor execution is part of the deployment cost
    constructor() {
        // msg.sender is the address that created the transaction 
        // (in this case, the account deploying the contract)
        minter = msg.sender;
    }

    /**
     * @dev Creates new coins and sends them to a recipient
     * @param receiver Address receiving the newly minted coins
     * @param amount Amount of coins to create
     * 
     * GAS COST: This function costs gas because:
     * 1. It modifies the state (balances mapping)
     * 2. More complex operations = more gas
     * 
     * SECURITY: Only the minter (contract owner) can call this
     */
    function mint(address receiver, uint amount) public {
        // require() checks a condition and reverts the transaction if false
        // Reverting means all changes are undone and remaining gas is returned
        require(msg.sender == minter, "Only the minter can create new coins");
        
        // Add coins to receiver's balance
        // GAS COST: Writing to a mapping costs gas
        balances[receiver] += amount;
    }

    // Custom errors are a gas-efficient way to explain why a transaction failed
    // They're more gas efficient than require statements with long error messages
    error InsufficientBalance(uint requested, uint available);

    /**
     * @dev Transfers coins from sender to receiver
     * @param receiver Address receiving the coins
     * @param amount Amount of coins to transfer
     * 
     * GAS COST: This function costs gas because:
     * 1. It modifies state (two balance changes)
     * 2. It emits an event
     * 3. It may revert with a custom error
     */
    function send(address receiver, uint amount) public {
        // Check if sender has enough coins
        // If not, revert with a custom error showing the details
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        // Update balances - subtract from sender, add to receiver
        // GAS COST: Each state modification costs gas
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        
        // Emit event for frontend applications or other contracts to detect
        // GAS COST: Emitting events costs gas but less than storing the same data
        emit Sent(msg.sender, receiver, amount);
    }
}