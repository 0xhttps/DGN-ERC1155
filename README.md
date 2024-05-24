# ERC1155-Builder

ERC1155-Builder is an ERC1155 token contract that allows for the creation of new ERC1155 tokens after deployment. The contract supports minting with both whitelist and public access and allows the owner to configure various minting parameters such as maximum supply, public mint limits, and mint statuses for each token.

## Features

- Creation of new ERC1155 tokens after deployment
- Minting with whitelist and public access
- Configurable minting parameters for each token
- Token metadata management
- Contract and minting status management

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (which includes npm)
- [Hardhat](https://hardhat.org/)

### Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/0xhttps/DGN.git
    cd DGN
    ```

2. **Install Dependencies**

    ```bash
    npm install
    ```

    If you encounter dependency conflicts, use the `--legacy-peer-deps` flag:

    ```bash
    npm install --legacy-peer-deps
    ```

3. **Install Hardhat**

    ```bash
    npm install --save-dev hardhat
    ```

### Configuration

Update your `hardhat.config.js` file to connect to the desired network.

### Deployment

1. **Compile the Contract**

    ```bash
    npx hardhat compile
    ```

2. **Deploy the Contract**

    ```bash
    npx hardhat run scripts/deploy.js --network rinkeby
    ```

## Usage

### Functions

- **`mint(uint _id)`**: Public and whitelist mint function.
- **`ownerBatchMint(uint _id, address _to, uint _amount)`**: Batch mint a specified amount of a token ID to a specified address.
- **`_setTokenURI(uint _id, string memory _uri)`**: Sets the URI for a specified token ID.
- **`_setTokenWhitelist(address[] calldata addresses, uint8 _id)`**: Sets the whitelist for a specified token ID.
- **`_setTokenSupply(uint _id, uint _maxSupply)`**: Sets the maximum supply for a specified token ID.
- **`_setPublicMintLimit(uint _id, uint _publicMintLimit)`**: Sets the public mint limit for a specified token ID.
- **`_setMintInfo(uint _id, MintStatus _status)`**: Sets the mint status for a specified token ID.
- **`_setContractStatus(ContractStatus _status)`**: Sets the contract status.
- **`getURI(uint _id)`**: Returns the URI of a specified token ID.
- **`getTokenMaxSupply(uint _id)`**: Returns the maximum supply of a specified token ID.
- **`getTokenCurrentSupply(uint _id)`**: Returns the current supply of a specified token ID.
- **`getTokenPublicMintLimit(uint _id)`**: Returns the public mint limit of a specified token ID.