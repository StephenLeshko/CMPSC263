// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MyToken - ERC20 Token Example
 * @dev This contract demonstrates creating a standard ERC20 token with additional features
 * 
 * IMPORTANT CONCEPTS:
 * - ERC20: A standard interface for fungible tokens (tokens where each unit is identical)
 * - OpenZeppelin: A library of secure, community-vetted smart contracts
 * - Inheritance: This contract extends multiple base contracts to gain their functionality
 * 
 * GAS CONSIDERATIONS:
 * - Using standard libraries saves gas by using optimized, audited code
 * - Each additional feature adds to the deployment cost
 */

// Import OpenZeppelin contracts - these are pre-written, secure contract templates
// GAS NOTE: Imports don't increase gas costs, but the code they contain does
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";        // Basic ERC20 functionality
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol"; // Adds ability to burn tokens
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol"; // Adds ability to pause transfers
import "@openzeppelin/contracts/access/Ownable.sol";           // Adds ownership controls
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol"; // Adds gasless approvals
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";  // Adds voting capabilities

/**
 * MyToken inherits from multiple base contracts. This means it gets all their
 * functionality without having to rewrite it.
 * 
 * GAS COST: The more features you add, the more expensive deployment
 * and interaction will be
 */
contract MyToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit, ERC20Votes {
    /**
     * @dev Constructor sets up the token with its name and symbol
     * @param initialOwner Address that will own the contract and have special permissions
     * 
     * GAS COST: Constructor execution is part of deployment cost
     */
    constructor(address initialOwner)
        ERC20("MyToken", "MTK")          // Sets the token name and symbol
        Ownable(initialOwner)           // Sets the owner of the contract
        ERC20Permit("MyToken")          // Sets up permit functionality with the token name
    {
        // Create initial supply: 100 tokens (with 18 decimals)
        // GAS COST: Minting tokens costs gas as it updates state
        _mint(msg.sender, 100 * 10 ** decimals());
    }

    /**
     * @dev Pauses all token transfers
     * SECURITY: Only the owner can call this function
     * 
     * GAS COST: This costs gas as it changes the contract state
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers
     * SECURITY: Only the owner can call this function
     * 
     * GAS COST: This costs gas as it changes the contract state
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Creates new tokens and assigns them to an address
     * @param to Address receiving the new tokens
     * @param amount Amount of tokens to create
     * 
     * SECURITY: Only the owner can create new tokens
     * GAS COST: Minting costs gas proportional to the state changes
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // The following functions are overrides required by Solidity.
    // OVERRIDES: When multiple parent contracts have the same function,
    // we need to specify how they should work together

    /**
     * @dev Internal function to handle token transfers
     * @param from Address sending tokens
     * @param to Address receiving tokens
     * @param value Amount of tokens being transferred
     * 
     * OVERRIDE EXPLANATION: This function exists in multiple parent contracts,
     * so we must override it to ensure all parent implementations are called correctly
     */
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable, ERC20Votes)
    {
        super._update(from, to, value);  // Call the parent implementations
    }

    /**
     * @dev Returns the current nonce for an address (used for permits)
     * @param owner Address to check the nonce for
     * @return Current nonce value
     * 
     * OVERRIDE EXPLANATION: This function exists in multiple parent contracts,
     * so we must specify which implementation to use
     * 
     * GAS COST: View functions are free when called externally
     */
    function nonces(address owner)
        public
        view
        override(ERC20Permit, Nonces)
        returns (uint256)
    {
        return super.nonces(owner);  // Call the parent implementation
    }
}