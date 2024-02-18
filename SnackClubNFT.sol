// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importing ERC1155 for NFT functionality, Ownable for ownership management, and Strings for string manipulation utilities
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// SnackClubNFT contract inherits ERC1155 for NFT operations and Ownable for access control
contract SnackClubNFT is ERC1155, Ownable(msg.sender) {
    // Using Strings library to convert uint256 to string
    using Strings for uint256;

    // Constants representing membership tiers
    uint256 public constant ADAMANTIUM = 1;
    uint256 public constant VIBRANIUM = 2;
    uint256 public constant DRAGONITE = 3;

    // Mapping to store the price of each tier
    mapping(uint256 => uint256) private _tierPrices;

    // Constructor to set the base URI for token metadata and initialize tier prices
    constructor(string memory baseURI) ERC1155(baseURI) {
        // Setting the prices for each membership tier
        _tierPrices[ADAMANTIUM] = 0.1 ether;
        _tierPrices[VIBRANIUM] = 0.2 ether;
        _tierPrices[DRAGONITE] = 0.3 ether;
    }

    // Function to mint new membership NFTs; payable to accept ETH
    function mintMembership(uint256 tier, uint256 amount) public payable {
        // Check if the tier exists and if enough ETH was sent
        require(_tierPrices[tier] != 0, "Tier does not exist");
        require(msg.value >= _tierPrices[tier] * amount, "Incorrect value sent");
        // Minting the NFT to the caller's address
        _mint(msg.sender, tier, amount, "");
    }

    // Allows the contract owner to set the price for a specific tier
    function setTierPrice(uint256 tier, uint256 price) public onlyOwner {
        _tierPrices[tier] = price;
    }

    // Public function to retrieve the price of a specific tier
    function getTierPrice(uint256 tier) public view returns (uint256) {
        return _tierPrices[tier];
    }

    // Allows the contract owner to update the base URI for metadata
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        _setURI(newBaseURI);
    }

    // Override the URI function to concatenate the base URI with the token ID
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(super.uri(tokenId), tokenId.toString()));
    }

    // Function for the contract owner to withdraw the contract's ETH balance
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        // Attempt to transfer the balance to the owner
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}
