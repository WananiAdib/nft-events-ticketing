// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Event is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint private n_tickets; 
    address payable admin;
    address public eventCreator;

    mapping(string => bool) existingURIs;
// uint256 _n_tickets
    constructor(address payable _admin) ERC721("Event", "MTK") {
        // n_tickets = _n_tickets;
        admin = _admin;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }
    
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Functions that I implemented


    function isTicketSold(string memory uri) public view returns (bool) {
        return existingURIs[uri];
    }
    // function mintTickets() public onlyOwner returns (bool){

    // }
    function payToMintTicket(address recipient, string memory metadataURI) public payable returns (uint256) {
        require(!existingURIs[metadataURI], 'ticket already minted!');
        require (msg.value == 10 ether, 'You need to pay 10!');

        admin.transfer(msg.value);
        uint256 newItemId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        existingURIs[metadataURI] = true;

        _mint(recipient, newItemId);
        _setTokenURI(newItemId, metadataURI);

        return newItemId;
    }

    function count() public view returns (uint256) {
        return _tokenIdCounter.current();
    }

}