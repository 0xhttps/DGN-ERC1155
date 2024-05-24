// SPDX-License-Identifier: MIT

/*
    Created by 0xhttps
    https://github.com/0xhttps
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155BUILDER is ERC1155, Ownable {

    // Enum to represent mint statuses.
    enum MintStatus {
        Paused,    //0
        Whitelist, //1
        Public     //2
    }

    // Enum to represent contract statuses.
    enum ContractStatus {
        Paused,    //0
        Active     //1
    }

    // Struct to hold information about each token.
    struct TokenInformation {
        uint currentSupply;
        uint maxSupply;
        string tokenUri;
    }

    // Struct to hold minting information.
    struct MintInformation {
        MintStatus status;
        uint publicMintLimit;
    }   

    string public name;
    string public symbol;
    mapping(uint => TokenInformation) public tokenInfo;
    mapping(uint => MintInformation) public mintInfo;
    mapping(address => uint) public tokenWhitelist;
    // Limits address to publicMintLimit per token.
    mapping(address => mapping(uint256 => uint256)) private addressData;

    ContractStatus private contractStatus = ContractStatus.Paused;

    constructor() ERC1155("") {
        name = "name";
        symbol = "symbol";
    } 

    /**
     * @dev Public and whitelist mint function.
     * @param _id The ID of the token to mint.
     */
    function mint(uint _id) public {
        require(msg.sender == tx.origin, "No transaction from smart contracts!"); 
        require(contractStatus != ContractStatus.Paused, "Mint is paused.");
        require(mintInfo[_id].status != MintStatus.Paused, "Mint must be active for specified ID");
        require(tokenInfo[_id].currentSupply + 1 <= tokenInfo[_id].maxSupply, "Must not exceed max supply!");
        if (mintInfo[_id].status == MintStatus.Whitelist) {
            require(tokenWhitelist[msg.sender] == _id, "Must be whitelisted for specified ID");
            tokenWhitelist[msg.sender] = 0;
        } else {
            require(addressData[msg.sender][_id] < mintInfo[_id].publicMintLimit, "Public mint limit reached");
            addressData[msg.sender][_id]++;
        }
        tokenInfo[_id].currentSupply++;
        _mint(msg.sender, _id, 1, "");
    }
    
    /**
     * @dev Batch mint x amount of specified token ID.
     * @param _id The ID of the token to mint.
     * @param _to The address to mint to.
     * @param _amount The amount of tokens to mint.
     */
    function ownerBatchMint(uint _id, address _to, uint _amount) external onlyOwner {
        require(_amount + tokenInfo[_id].currentSupply <= tokenInfo[_id].maxSupply, "Must not exceed max supply of ID!" );
        tokenInfo[_id].currentSupply += _amount;
         _mint(_to, _id, _amount, "");
    }

    /**
     * @dev Sets URI for specified token ID.
     * @param _id The ID of the token.
     * @param _uri The URI to set.
     */
    function _setTokenURI(uint _id, string memory _uri) external onlyOwner {
        tokenInfo[_id].tokenUri = _uri;
        emit URI(_uri, _id);
    }

    /**
     * @dev Sets whitelist for specified token ID.
     * @param addresses The addresses to whitelist.
     * @param _id The ID of the token.
     */
    function _setTokenWhitelist(address[] calldata addresses, uint8 _id) external onlyOwner {
        require(tokenInfo[_id].maxSupply != 0, "Cannot set whitelist for token that does not exist.");
        for (uint256 i = 0; i < addresses.length; i++) {
             tokenWhitelist[addresses[i]] = _id;
        }
    }

    /**
     * @dev Set max supply for specified token ID.
     * @param _id The ID of the token.
     * @param _maxSupply The maximum supply of the token.
     */
    function _setTokenSupply(uint _id, uint _maxSupply) external onlyOwner {
        require(tokenInfo[_id].currentSupply < _maxSupply, "Current supply exceeds new supply");
        tokenInfo[_id].maxSupply = _maxSupply; 
    }

    /**
     * @dev Sets public mint limit for a specified token ID.
     * @param _id The ID of the token.
     * @param _publicMintLimit The public mint limit to set.
     */
    function _setPublicMintLimit(uint _id, uint _publicMintLimit) external onlyOwner {
        require(tokenInfo[_id].maxSupply != 0, "Cannot set public mint limit for token ID that doesnt exist.");
        mintInfo[_id].publicMintLimit = _publicMintLimit;
    }   

    /**
     * @dev Sets mint info of specified token ID.
     * @param _id The ID of the token.
     * @param _status The mint status to set.
     */
    function _setMintInfo(uint _id, MintStatus _status) external onlyOwner {
        mintInfo[_id].status = _status;
    }
   
    /**
     * @dev Sets contract status.
     * @param _status The contract status to set.
     */
    function _setContractStatus(ContractStatus _status) external onlyOwner {
        contractStatus = _status;
    }

    /**
     * @dev Returns URI of specified token ID.
     * @param _id The ID of the token.
     * @return The URI of the token.
     */
    function getURI(uint _id) public view returns (string memory) {
        return tokenInfo[_id].tokenUri;
    }

    /**
     * @dev Returns max supply of specified token ID.
     * @param _id The ID of the token.
     * @return The max supply of the token.
     */
    function getTokenMaxSupply(uint _id) public view returns (uint) {
        return tokenInfo[_id].maxSupply;
    }

    /**
     * @dev Returns current supply of specified token ID.
     * @param _id The ID of the token.
     * @return The current supply of the token.
     */
    function getTokenCurrentSupply(uint _id) public view returns (uint) {
        return tokenInfo[_id].currentSupply;
    }

    /**
     * @dev Returns public mint limit of specified token ID.
     * @param _id The ID of the token.
     * @return The public mint limit of the token.
     */
    function getTokenPublicMintLimit (uint _id) public view returns (uint) {
        return mintInfo[_id].publicMintLimit;
    }
}
