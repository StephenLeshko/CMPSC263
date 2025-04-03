// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Simple ERC721 (NFT) Contract
 * @dev This contract demonstrates creating non-fungible tokens (NFTs)
 * 
 * IMPORTANT CONCEPTS:
 * - ERC721: The standard for non-fungible tokens on Ethereum
 * - NFT: Non-Fungible Tokens are unique and not interchangeable (unlike ERC20)
 * - TokenURI: Links each token to its metadata (usually JSON with image links)
 * - IPFS: Decentralized file storage often used for NFT metadata and images
 * 
 * GAS CONSIDERATIONS:
 * - Minting NFTs costs gas per token
 * - Using IPFS for metadata is gas-efficient as you only store a reference on-chain
 */

// Import OpenZeppelin contracts - these are pre-written, secure contract templates
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";          // Base NFT functionality
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol"; // Adds ability to burn tokens
import "@openzeppelin/contracts/access/Ownable.sol";               // Adds ownership controls

/**
 * @dev This contract creates a simple NFT collection with minting and burning capabilities
 * 
 * INHERITANCE: Gets functionality from multiple parent contracts
 * - ERC721: Basic NFT standard implementation
 * - ERC721Burnable: Adds ability to destroy tokens
 * - Ownable: Adds access control for special functions
 */
contract MyToken is ERC721, ERC721Burnable, Ownable {
    // Counter to keep track of the next token ID to mint
    // GAS COST: State variables cost gas to initialize and modify
    uint256 private _nextTokenId;

    /**
     * @dev Constructor sets up the NFT collection with name and symbol
     * @param initialOwner Address that will own the contract and have minting rights
     * 
     * GAS COST: Constructor execution is part of deployment cost
     */
    constructor(address initialOwner)
        ERC721("MyToken", "MTK")        // Sets the collection name and symbol
        Ownable(initialOwner)           // Sets the owner of the contract
    {}

    /**
     * @dev Returns the base URI for all token metadata
     * @return Base URI string that prefixes all token URIs
     * 
     * GAS EFFICIENCY: This is marked 'pure' as it doesn't read state
     * 
     * IMPORTANT: In a real NFT, you would set this to your IPFS gateway or API
     */
    function _baseURI() internal pure override returns (string memory) {
        return "{could_have_gateway_here_for_simplicty}/ipfs/{cid}/";
    }

    /**
     * @dev Creates a new NFT and assigns it to the recipient
     * @param to Address that will receive the new NFT
     * 
     * SECURITY: Only the owner can mint new tokens
     * GAS COST: Minting NFTs costs gas for:
     * 1. Incrementing the token counter
     * 2. Updating ownership mappings
     * 3. Emitting transfer events
     */
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;  // Get current ID and increment for next time
        _safeMint(to, tokenId);            // Mint the token safely (with checks)
    }

    /**
     * @dev Returns the complete URI for a specific token's metadata
     * @param tokenId The ID of the token to get the URI for
     * @return Complete URI string pointing to the token's metadata
     * 
     * METADATA: This function tells applications where to find:
     * - The NFT's image
     * - The NFT's name, description, and attributes
     * 
     * GAS EFFICIENCY: View functions are free when called externally
     */
    function tokenURI(uint256 tokenId) public view 
    override virtual returns (string memory) {
        // Verify the token exists and has an owner
        _requireOwned(tokenId);

        // Build the complete URI by combining base URI and token ID
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, integerToString(tokenId),".json") : "";
    }

    /**
     * @dev Helper function to convert integers to strings
     * @param _value Integer to convert
     * @return String representation of the integer
     * 
     * GAS EFFICIENCY: Marked as pure since it doesn't read or modify state
     * 
     * NOTE: Solidity doesn't have built-in integer-to-string conversion,
     * so we implement it manually
     */
    function integerToString(uint _value) public pure returns (string memory) {
        // Edge case for '0'
        if (_value == 0) {
            return "0";
        }

        // Calculate number of digits
        uint temp = _value;
        uint digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        // Convert each digit to ASCII character
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits -= 1;
            // ASCII '0' is 48, so we add the digit value to 48
            buffer[digits] = bytes1(uint8(48 + _value % 10));
            _value /= 10;
        }

        return string(buffer);
    }
}