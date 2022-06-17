// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/utils/Strings.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';

contract PixelPrints is ERC721A, Ownable {
    using Strings for uint256;

    uint256 public constant MAX_TOKENS = 333;

    uint256 public price = 0.05 ether;
    uint256 public maxMint = 1;
    bool public publicSale = false;
    bool public whitelistSale = false;

    mapping(address => uint256) public _whitelistClaimed;

    string public baseURI = "https://gateway.pinata.cloud/ipfs/QmdEXk9vs7aC3akWhw8MnM4XBXqWBnwrFC7pn1Q96D7uZB/";
    bytes32 public merkleRoot = 0xb02791eae516b1116dd8be4c05ee7bcea567d61ed5de3b1e025df80820806b79;

    constructor() ERC721A("PIXELPRINTS", "PASS") {
    }

    function toggleWhitelistSale() external onlyOwner {
        whitelistSale = !whitelistSale;
    }

    function togglePublicSale() external onlyOwner {
        publicSale = !publicSale;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }

    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setPrice(uint256 _price) public onlyOwner {
        price = _price;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //change max mint 
    function setMaxMint(uint256 _newMaxMint) external onlyOwner {
        maxMint = _newMaxMint;
    }

    //wl only mint
    function whitelistMint(uint256 tokens, bytes32[] calldata merkleProof) external payable {
        require(whitelistSale, "You can not mint right now");
        require(MerkleProof.verify(merkleProof, merkleRoot, keccak256(abi.encodePacked(msg.sender))), "You are not on the whitelist");
        require(_whitelistClaimed[_msgSender()] + tokens <= maxMint, "Cannot mint this many pass");
        require(tokens > 0, "Please mint at least 1 pass");
        require(price * tokens == msg.value, "Not enough ETH");

        _safeMint(_msgSender(), tokens);
        _whitelistClaimed[_msgSender()] += tokens;
    }

    //mint function for public
    function mint(uint256 tokens) external payable {
        require(publicSale, "Public sale has not started");
        require(tokens <= maxMint, "Cannot purchase this many tokens in a transaction");
        require(totalSupply() + tokens <= MAX_TOKENS, "Exceeded supply");
        require(tokens > 0, "Please mint at least 1 Pass");
        require(price * tokens == msg.value, "Not enough ETH");
        _safeMint(_msgSender(), tokens);
    }

    // Owner mint has no restrictions. use for giveaways, airdrops, etc
    function ownerMint(address to, uint256 tokens) external onlyOwner {
        require(totalSupply() + tokens <= MAX_TOKENS, "Minting would exceed max supply");
        require(tokens > 0, "Must mint at least one token");
        _safeMint(to, tokens);
    }

    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
  }
}


    