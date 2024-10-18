//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PropyKeys is ERC721 {
    constructor() ERC721("PropyKeys", "PPK") {
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://propy.com/nft/";
    }
    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}