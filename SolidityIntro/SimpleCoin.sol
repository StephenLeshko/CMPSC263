// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title A simple token implementation
/// @notice This demonstrates mappings, events, and transfer functionality
contract SimpleCoin {
    // State variables
    address public owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    
    // Mapping of address to balance
    mapping(address => uint256) public balanceOf;
    
    // Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Mint(address indexed _to, uint256 _value);
    
    /// @notice Constructor to initialize the token
    /// @param _initialSupply The initial token supply to mint
    /// @param _name The name of the token
    /// @param _symbol The symbol of the token
    constructor(
        uint256 _initialSupply,
        string memory _name,
        string memory _symbol
    ) {
        owner = msg.sender;
        name = _name;
        symbol = _symbol;
        decimals = 18;
        
        // Mint initial supply to the creator
        balanceOf[msg.sender] = _initialSupply * 10**uint256(decimals);
        emit Mint(msg.sender, balanceOf[msg.sender]);
    }
    
    /// @notice Transfer tokens to another address
    /// @param _to The recipient address
    /// @param _value The amount to send
    /// @return success Whether the transfer succeeded
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // Check if the sender has enough balance
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow detected");
        
        // Subtract from the sender
        balanceOf[msg.sender] -= _value;
        
        // Add to the recipient
        balanceOf[_to] += _value;
        
        // Emit transfer event
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    /// @notice Only the owner can mint new tokens
    /// @param _to The address that will receive the minted tokens
    /// @param _value The amount of tokens to mint
    /// @return success Whether the minting succeeded
    function mint(address _to, uint256 _value) public returns (bool success) {
        // Only owner can mint new tokens
        require(msg.sender == owner, "Only owner can mint");
        
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to], "Overflow detected");
        
        // Add to the recipient's balance
        balanceOf[_to] += _value;
        
        // Emit events
        emit Mint(_to, _value);
        emit Transfer(address(0), _to, _value);
        
        return true;
    }
    
    /// @notice Get the total supply of tokens
    /// @return The total supply
    function totalSupply() public view returns (uint256) {
        // This is a simplified implementation
        // Real tokens would track total supply as a state variable
        return balanceOf[owner];
    }
} 