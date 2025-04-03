// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ContractWithinContract - Internal Function Demo
 * @dev This example demonstrates how internal functions work in contract hierarchies
 * 
 * KEY CONCEPTS:
 * - Internal: Functions accessible within the current contract and contracts that inherit from it
 * - Inheritance: When one contract extends another to reuse its code
 * - Contract Composition: Building complex contracts from simpler parts
 */

/**
 * @title TokenBase
 * @dev Base contract containing core internal token functionality
 * 
 * This contract is not meant to be deployed on its own. Instead, it serves as a
 * foundation for other contracts to inherit from. Its internal functions provide
 * the core logic for handling token operations.
 */
contract TokenBase {
    // Balances mapping for accounts
    mapping(address => uint256) internal _balances;
    
    // Total token supply
    uint256 internal _totalSupply;
    
    // Events to notify external applications
    event Transfer(address indexed from, address indexed to, uint256 value);
    
    /**
     * @dev Internal function to perform token transfers
     * The 'internal' keyword means this function:
     * - CAN be called by this contract itself
     * - CAN be called by contracts that inherit from this one
     * - CANNOT be called by external accounts or contracts
     * - CANNOT be called via transactions
     * 
     * @param from Address sending the tokens
     * @param to Address receiving the tokens
     * @param amount Amount of tokens to transfer
     * @return bool Success indicator
     */
    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        // Require valid addresses
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");
        
        // Check balance is sufficient
        require(_balances[from] >= amount, "Insufficient balance");
        
        // Update balances
        _balances[from] -= amount;
        _balances[to] += amount;
        
        // Emit transfer event
        emit Transfer(from, to, amount);
        
        return true;
    }
    
    /**
     * @dev Internal function to create new tokens
     * @param account Address to receive the tokens
     * @param amount Amount of tokens to create
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero address");
        
        _totalSupply += amount;
        _balances[account] += amount;
        
        emit Transfer(address(0), account, amount);
    }
    
    /**
     * @dev Internal function to destroy tokens
     * @param account Address to burn tokens from
     * @param amount Amount of tokens to burn
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "Burn from zero address");
        require(_balances[account] >= amount, "Burn amount exceeds balance");
        
        _balances[account] -= amount;
        _totalSupply -= amount;
        
        emit Transfer(account, address(0), amount);
    }
    
    /**
     * @dev Internal pure function for validation checks
     * 'pure' means it doesn't read or modify state
     * @param value Amount to check
     * @return True if valid amount
     */
    function _isValidAmount(uint256 value) internal pure returns (bool) {
        return value > 0;
    }
}

/**
 * @title TokenPool
 * @dev A simple token contract that inherits from TokenBase
 * 
 * This contract:
 * 1. Inherits all internal functions from TokenBase
 * 2. Implements external functions that users can call
 * 3. Uses the internal functions as building blocks for its features
 * 
 * The internal functions from TokenBase are like a toolkit that this contract uses
 * but are NOT directly accessible to external users.
 */
contract TokenPool is TokenBase {
    string public name;
    string public symbol;
    address public owner;
    
    // Exchange rates for the token pool
    uint256 public buyRate;  // How many tokens per ETH when buying
    uint256 public sellRate; // How many tokens per ETH when selling
    
    /**
     * @dev Constructor sets up the token details and exchange rates
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        uint256 _buyRate,
        uint256 _sellRate
    ) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        buyRate = _buyRate;
        sellRate = _sellRate;
        
        // Use the internal _mint function from TokenBase
        _mint(msg.sender, _initialSupply);
    }
    
    /**
     * @dev Public function to view user's balance
     * @param account Address to check
     * @return User's token balance
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account]; // Directly access internal variable
    }
    
    /**
     * @dev Public function to view total supply
     * @return Total token supply
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply; // Directly access internal variable
    }
    
    /**
     * @dev Public function allowing users to transfer tokens
     * @param to Recipient address
     * @param amount Amount to transfer
     * @return Success indicator
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        // Call the internal _transfer function from TokenBase
        return _transfer(msg.sender, to, amount);
    }
    
    /**
     * @dev Allow users to buy tokens with ETH
     * Note how this calls multiple internal functions
     */
    function buyTokens() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        
        // Calculate tokens to mint based on ETH sent
        uint256 tokenAmount = msg.value * buyRate;
        
        // Validate using internal function
        require(_isValidAmount(tokenAmount), "Invalid amount");
        
        // Mint tokens to buyer using internal function
        _mint(msg.sender, tokenAmount);
    }
    
    /**
     * @dev Allow users to sell tokens for ETH
     * @param tokenAmount Amount of tokens to sell
     */
    function sellTokens(uint256 tokenAmount) public {
        require(_isValidAmount(tokenAmount), "Amount must be greater than 0");
        require(_balances[msg.sender] >= tokenAmount, "Insufficient balance");
        
        // Calculate ETH to send
        uint256 ethAmount = tokenAmount / sellRate;
        require(address(this).balance >= ethAmount, "Insufficient liquidity");
        
        // Burn tokens using internal function
        _burn(msg.sender, tokenAmount);
        
        // Send ETH to seller
        (bool success, ) = payable(msg.sender).call{value: ethAmount}("");
        require(success, "ETH transfer failed");
    }
    
    /**
     * @dev Admin function to update exchange rates
     * @param newBuyRate New buy rate
     * @param newSellRate New sell rate
     */
    function updateRates(uint256 newBuyRate, uint256 newSellRate) public {
        require(msg.sender == owner, "Only owner can update rates");
        buyRate = newBuyRate;
        sellRate = newSellRate;
    }
    
    /**
     * @dev Allow contract to receive ETH
     */
    receive() external payable {}
}

/**
 * @title AdminExtension
 * @dev Another contract that inherits from TokenPool for admin functions
 * 
 * This demonstrates multi-level inheritance, where internal functions from
 * TokenBase are available through the inheritance chain.
 */
contract AdminExtension is TokenPool {
    mapping(address => bool) public admins;
    
    /**
     * @dev Constructor passes arguments to parent contract
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        uint256 _buyRate,
        uint256 _sellRate
    ) TokenPool(_name, _symbol, _initialSupply, _buyRate, _sellRate) {
        admins[msg.sender] = true;
    }
    
    /**
     * @dev Modifier for admin-only functions
     */
    modifier onlyAdmin() {
        require(admins[msg.sender], "Admin access required");
        _;
    }
    
    /**
     * @dev Add a new admin
     * @param newAdmin Address of new admin
     */
    function addAdmin(address newAdmin) public onlyAdmin {
        admins[newAdmin] = true;
    }
    
    /**
     * @dev Mint additional tokens (admin only)
     * @param to Recipient address
     * @param amount Amount to mint
     */
    function adminMint(address to, uint256 amount) public onlyAdmin {
        // Can call _mint because it's internal in the parent chain
        _mint(to, amount);
    }
    
    /**
     * @dev Burn tokens from any account (admin only)
     * @param from Address to burn from
     * @param amount Amount to burn
     */
    function adminBurn(address from, uint256 amount) public onlyAdmin {
        // Can call _burn because it's internal in the parent chain
        _burn(from, amount);
    }
    
    /**
     * @dev Emergency withdraw if needed
     * @param amount Amount of ETH to withdraw
     */
    function emergencyWithdraw(uint256 amount) public onlyAdmin {
        require(amount <= address(this).balance, "Insufficient contract balance");
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "ETH transfer failed");
    }
}

/** 
 * VISIBILITY SUMMARY
 * 
 * public    - Anyone can call (external contracts, derived contracts, internally)
 * external  - Only external contracts can call (not internally)
 * internal  - Only this contract and derived contracts can call
 * private   - Only this contract can call (not even derived contracts)
 * 
 * The internal keyword is particularly useful for:
 * 1. Creating reusable logic that derived contracts can use
 * 2. Protecting critical functions from being called directly by users
 * 3. Building modular smart contract systems
 */ 